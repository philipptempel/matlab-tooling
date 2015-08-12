function [length, varargout] = algoInverseKinematics_Simple(Pose, PulleyPositions, CableAttachments)
% ALGOINVERSEKINEMATICS_SIMPLE - Perform inverse kinematics for the given
%   pose of the virtual robot
%   Inverse kinematics means to determine the values for the joint
%   variables (in this case cable lengths) for a given endeffector pose.
%   This is quite a simple setup for cable-driven parallel robots because
%   the equation for the kinematic loop has to be solved, which is the sole
%   purpose of this method.
%   It can determine the cable lengths for any given robot configuration
%   (note that calculations will be done as if we were looking at a 3D/6DOF
%   cable robot following necessary conventions, so adjust your variables
%   accordingly). To determine the cable lengths, both the simple kinematic
%   loop can be used as well as the advanced pulley kinematics (considering
%   pulley radius and rotatability).
% 
%   LENGTH = ALGOINVERSEKINEMATICS_SIMPLE(POSE, PULLEYPOSITIONS, CABLEATTACHMENTS)
%   performs simple inverse kinematics with the cables running from a_i to
%   b_i for the given pose
% 
%   [LENGTH, CABLEUNITVECTOR] = ALGOINVERSEKINEMATICS_SIMPLE(...) also provides
%   the unit vectors for each cable which might come in handy at times because
%   it provides the direction of the force created by the cable on the mobile
%   platform.
% 
%   [LENGTH, CABLEUNITVECTOR, PULLEYANGLES] = ALGOINVERSEKINEMATICS_SIMPLE(...)
%   additionally returns the angle of rotation that the cable local frame has
%   relative to the world frame's z_0
% 
%   [LENGTH, CABLEUNITVECTOR, PULLEYANGLES, CABLESHAPE] =
%   ALGOINVERSEKINEMATICS_SIMPLE(...) additionally returns the shape of the
%   cable in the cable's local frame with a discretization of K = 10e4 points
%   
%   
%   Inputs:
%   
%   POSE: The current robots pose given as a 12-column row vector that has
%   the [x, y, z] position in the first three entries and then follwing are
%   the entries of the rotation matrix such that the vector POSE looks
%   something like this
%   pose = [x, y, z, R11, R12, R13, R21, R22, R23, R31, R32, R33]
% 
%   PULLEYPOSITIONS: Matrix of pulley positions w.r.t. the world frame. Each
%   pulley has its own column and the rows are the x, y, and z-value,
%   respectively i.e., PULLEYPOSITIONS must be a matrix of 3xM values. The
%   number of pulleys i.e., N, must match the number of cable attachment
%   points in CABLEATTACHMENTS (i.e., its column count) and the order must
%   mach the real linkage of pulley to cable attachment on the platform
% 
%   CABLEATTACHMENTS: Matrix of cable attachment points w.r.t. the
%   platforms coordinate system. Each attachment point has its own column
%   and the rows are the x, y, and z-value, respectively, i.e.,
%   CABLEATTACHMENTS must be a matrix of 3xM values. The number of cables
%   i.e., N, must match the number of pulleys in PULLEYPOSITIONS (i.e., its
%   column count) and the order must match the real linkage of cable
%   attachment on the platform to pulley.
% 
%   Outputs:
% 
%   LENGTH: Length is a vector of size 1xM with the cable lengths
%   determined using either simple or advanced kinematics
%   
%   CABLEUNITVECTOR: Normalized vector for each cable from attachment point
%   to its corrected pulley point as 3xM matrix
%   
%   PULLEYANGLES: Vector of gamma angles of rotation of the cable plane relative
%   to the world frame, given as 1xM vector where the column is the respective
%   pulley
%   
%   CABLESHAPE: Array of [2xKxM] points with the cable shape. First dimension is
%   the cable's local frame's x and z coordinate, second is the discretization
%   along the length of L with K-many steps, M is the number of cables
% 
% Author: Philipp Tempel <philipp.tempel@isw.uni-stuttgart.de>
% Date: 2015-06-24
% Changelog:
%   2015-06-24
%       * Add return value CABLESHAPE and remove CABLEVECTOR
%       * Add return value PULLEYANGLES
%   2015-04-22
%       * Initial release



%% Initialize variables
% To unify variable names
aCableAttachments = CableAttachments;
aPulleyPositions = PulleyPositions;
nNumberOfCables = size(aPulleyPositions, 2);
% Holds the actual cable vector
aCableVector = zeros(3, nNumberOfCables);
% Holds the normalized cable vector
aCableVectorUnit = zeros(3, nNumberOfCables);
% Holds the cable lengths
vCableLength = zeros(1, nNumberOfCables);
% Extract the position from the pose
vPlatformPosition = reshape(Pose(1:3), 3, 1);
% Extract rotatin from the pose
aPlatformRotation = rotationRowToMatrix(Pose(4:12));
% Hold the local rotation angles of each cable's local frame relative to K_0
aPulleyAngles = zeros(1, nNumberOfCables);
% This will hold the return value of the cable shape
nDiscretizationPoints = 10e3;
aCableShape = zeros(2, nDiscretizationPoints, nNumberOfCables);



%% Do the magic
% Loop over every pulley and ...
for iCable = 1:nNumberOfCables
    % Calculate the cable vector
    aCableVector(:,iCable) = aPulleyPositions(:,iCable) - ( vPlatformPosition + aPlatformRotation*aCableAttachments(:,iCable) );
    
    % Calculate the cable length
    vCableLength(iCable) = norm(aCableVector(:,iCable));
    
    % Calculate the direciton of the unit vector of the current cable
    aCableVectorUnit(:,iCable) = aCableVector(:,iCable)./vCableLength(iCable);
end



%% Output parsing
% First output is the cable lengths
length = vCableLength;

% Further outputs as requested
% Second output is the matrix of normalized cable vectors
if nargout > 1
    varargout{1} = aCableVectorUnit;
end

% Third output is the rotation angle of each cable plane
if nargout > 2
    %%% Calculate the cable shape if requested
    for iCable = 1:nNumberOfCables
        % ... calculate the angle of rotation of the cable local frame K_c
        % relative to K_0
        dRotationAngleAbout_kCz_Degree = atan2d(-aCableVector(2,iCable), -aCableVector(1,iCable));
        
        aPulleyAngles(1,iCable) = dRotationAngleAbout_kCz_Degree;
    end
    
    varargout{2} = aPulleyAngles;
end

% Fourth output is the cable shape
if nargout > 3
    %%% Calculate the cable shape if requested
    for iCable = 1:nNumberOfCables
        % Rotation matrix about K_C
        aRotation_kC2kA = rotz(aPulleyAngles(1,iCable));

        % Vector from A to B in K_C
        vA2B_in_C = transpose(aRotation_kC2kA)*(-aCableVector(:,iCable));
        % Normalize the vector from A^c to B^c
        vCableUnitVector_in_C = vA2B_in_C./norm(vA2B_in_C);

        % Calculate the z coordinate of the cable in its local frame
        % parametrized as
        % x = L_t*cos(dAngleOfCableWithXc) with 0 <= L_t <= L_i
        % t = L_t*sin(dAngleOfCableWithXc) with 0 <= L_t <= L_i
        vLinspaceOfCableLength = linspace(0, vCableLength(iCable), nDiscretizationPoints);
        aCableShape(1,:,iCable) = vCableUnitVector_in_C(1).*vLinspaceOfCableLength;
        aCableShape(2,:,iCable) = vCableUnitVector_in_C(3).*vLinspaceOfCableLength;
    end
    
    varargout{3} = aCableShape;
end


end

%------------- END OF CODE --------------
% Please send suggestions for improvement of this file to the original
% author as can be found in the header
% Your contribution towards improving this funciton will be acknowledged in
% the "Changes" section of the header
