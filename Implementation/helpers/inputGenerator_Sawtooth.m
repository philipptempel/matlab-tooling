function [SawtoothValue, varargout] = inputGenerator_Sawtooth(CurrentTime, Period, Amplitude, Offset, Algorithm)

if nargin < 2
    Period = 2*pi;
end

if nargin < 3
    Amplitude = 1;
end

if nargin < 4
    Offset = 0;
end

if nargin < 5
    Algorithm = 'simple';
end

dTimeEval = CurrentTime*pi/Period;

switch lower(Algorithm)
    case 'atan'
        SawtoothValue = Offset - 2*Amplitude/pi*atan(cot(dTimeEval));
    otherwise
        SawtoothValue = Offset + Amplitude*(dTimeEval/pi - floor(dTimeEval/pi));
end

end
