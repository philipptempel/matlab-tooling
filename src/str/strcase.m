function s = strcase(s, caseType)
%% STRCASE Change string case
%
%  STRCASE(S, caseType) converts the case of string S to caseType. Can be a
%  single string, or a cell/char array of strings. New lines or carriage returns
%  in the string will be converted to white space.
%
%    |-------------|------------------|------------------|
%    | caseType    | SAMPLE INPUT     | SAMPLE OUTPUT    |
%    |-------------|------------------|------------------|
%    | upper       | upper Case       | UPPER CASE       |
%    | lower       | Lower Case       | lower case       |
%    | title       | title is a good  | Title is a Good  |
%    | sentence    | sentence case    | Sentence case    |
%    | camel       | camEl casE       | camelCase        |
%    | lowerCamel  | LOWER caMel      | lowerCamel       |
%    | upperCamel  | upper CAMEL      | UpperCame        |
%    | snake       | Snake CASE here  | snake_case_here  |
%    |-------------|------------------|------------------|
%
%  EXAMPLES:
%  ------------------------------------------------------------------------
%  upper/lower:  This is pretty much the same as just using the built-in
%                matlab upper() and lower() functions.
%
%    changeCase('sample text','upper')  returns 'SAMPLE TEXT'
%    changeCase('Sample Text','toggle') returns 'sample text'
%  ------------------------------------------------------------------------
%  title: The first letter of each word is capitalized. The function
%         contains a list of small words like 'a', 'the', 'in', etc. that
%         will be lower case. There is also a list of acronyms that
%         will be upper case, e.g. 'GPS', 'NMEA', 'WTF', 'YOLO'
%
%    changeCase('never gonna give you up', 'title')
%      returns 'Never Gonna Give You Up'
%
%    changeCase('i''m IN THE moOD for love', 'title')
%      returns 'I'm in the Mood for Love'
%
%    changeCase('wtf is happENing here', 'title')
%      returns 'WTF is Happening Here'
%
%    changeCase('thisIsCamelCase', 'title')
%      returns 'This is Camel Case'
%
%    changeCase('this_Is_SNAKE_Case_yolo', 'title')
%      returns 'This is Snake Case YOLO'
%
%  ------------------------------------------------------------------------
%  sentence: The first letter of the first word is capitalized. All others
%            are lower case unless there are in the keepUpper list of
%            acronyms, in which case they are upper.
%
%    changeCase('i''m IN THE moOD for love', 'sentence')
%      returns 'I'm in the mood for love'
%
%    changeCase('wtf is happENing here', 'title')
%      returns 'WTF is happening here'
%
%  ------------------------------------------------------------------------
%  camel/lowerCamel: Words are mashed together with the first letter of
%                    each word a capital. The very first letter is lower.
%                    all symbols and whitespace is purged. Acronyms in the
%                    keepUpper list remain all upper.
%
%    changeCase('i''m IN THE moOD for love', 'camel')
%      returns 'iMInTheMoodForLove'
%
%    changeCase('today is good to yolo!!!!', 'camel')
%      returns 'todayIsGoodToYOLO'
%
%  REMARKS:
%    The uncamel part may do unexpected things if you pass in strings
%    without spaces that are not in camel case.
%
% Inspired by File ID: #6275 caseconvert
%
% Captain Awesome, February 2017


caseType = lower(caseType);

if isempty(s)
  return
end

if iscell(s)
  s = cellfun(@(x) strcase(s, caseType),...
    s, 'uniformoutput', false);
  return
end

%% ------------------------------------------------------------------------
if isempty(s)
  return
end

if ~ischar(s)
  error('It should really be a char string here.');
end

keepLower = lower({'a','an','and','or','in','the','with','at','is','for'});
keepUpper = upper({'ASCII','GPS','ID','NMEA','GPS','WTF','YOLO'});
keepProper = {'Bill', 'Ted', 'Florida', 'Canada'};

s = uncamel(s,keepUpper);
s = unsnake(s);

if strcmpi(caseType,'upper')
  s = upper(s);
  return
end

if strcmpi(caseType,'lower')
  s = lower(s);
  return
end

% Convert all white space to spaces. This will remove all tabs and newline
% characters as well.
s(isstrprop(s,'wspace')) = ' ';
if ismember(caseType,{'camel','lowercamel','uppercamel','snake'})
  s(~isstrprop(s,'alphanum')) = ' ';
end

% Split string into individual words
Sw = regexp(s,'[ \t]','split');

% Cycle through each word
cnt = 0;

for k=1:length(Sw)
  
  str = Sw{k};
  isl = isletter(str);
  
  if ~sum(isl)
    % Skip word if no letters
    continue
  end
  cnt = cnt+1;
  
  switch caseType
    
    case 'title'
      
      str2 = str(isl);
      if ismember(lower(str2), keepLower) && k>1
        str2 = lower(str2);
      elseif ismember(upper(str2), keepUpper) || length(str2)==1
        str2 = upper(str2);
      else
        str2 = [upper(str2(1)) lower(str2(2:end))];
      end
      str(isl) = str2;
      Sw{k} = str;
      
      
    case 'sentence'
      
      str2 = str(isl);
      if ismember(lower(str2), keepLower) && cnt>1
        str2 = lower(str2);
      elseif ismember(upper(str2), keepUpper) || length(str2)==1
        str2 = upper(str2);
      elseif ismember(lower(str2), lower(keepProper))
        str2 = keepProper{strcmpi(str2,keepProper)};
      elseif cnt==1
        str2 = [upper(str2(1)) lower(str2(2:end))];
      else
        str2 = lower(str2);
      end
      str(isl) = str2;
      Sw{k} = str;
      
    case {'camel','lowercamel'}
      
      str2 = str(isl);
      if ismember(upper(str2), keepUpper)
        str2 = upper(str2);
      elseif cnt>1
        str2 = [upper(str2(1)) lower(str2(2:end))];
      end
      str(isl) = str2;
      Sw{k} = str;
      
    case 'uppercamel'
      
      str2 = str(isl);
      if ismember(upper(str2), keepUpper)
        str2 = upper(str2);
      else
        str2 = [upper(str2(1)) lower(str2(2:end))];
      end
      str(isl) = str2;
      Sw{k} = str;
      
    case 'snake'
      
      str2 = str(isl);
      if ismember(upper(str2), keepUpper)
        str2 = upper(str2);
      elseif ismember(lower(str2), lower(keepProper))
        str2 = keepProper{strcmpi(str2,keepProper)};
      else
        str2 = lower(str2);
      end
      str(isl) = str2;
      Sw{k} = str;
      
    otherwise
      
      error(['bad caseType: ',caseType]);
      
  end % switch block
  
  clear isl str str2
end % Sw loop
if ismember(caseType,{'camel','lowercamel','uppercamel'})
  
  Sw(cellfun('isempty',Sw)) = [];
  s = sprintf('%s',Sw{:});
  
elseif ismember(caseType,{'snake'})
  
  Sw(cellfun('isempty',Sw)) = [];
  s = sprintf('%s_',Sw{:});
  s(end)='';
  
else
  
  s = sprintf('%s ',Sw{:});
  s(end)='';
  
end
end


function W = uncamel(S,keepUpper)
%% UNCAMEL


if length(S) ~= sum(isstrprop(S,'alphanum')) || ...
    length(S) == sum(isstrprop(S,'upper')) || ...
    length(S) == sum(isstrprop(S,'lower')) || ...
    length(S) == sum(isstrprop(S,'digit'))
  W = S;
  return
end


% First space out all the keepUpper bits
for k = 1:length(keepUpper)
  ku = keepUpper{k};
  id = strfind(S,ku);
  if isempty(id)
    continue
  end
  for p = 1:length(id)
    id2 = strfind(S,ku);
    S = [S(1:id2(p)+length(ku)-1),' ',S(id2(p)+length(ku):end)];
  end
end


W = S(1);

for k=2:length(S)
  if isstrprop(S(k),'digit') && isstrprop(S(k-1),'alpha')
    W(end+1) = ' ';
  elseif isstrprop(S(k),'alpha') && isstrprop(S(k-1),'digit')
    W(end+1) = ' ';
  elseif isstrprop(S(k),'upper') && isstrprop(S(k-1),'lower')
    W(end+1) = ' ';
  elseif k>3 && isstrprop(S(k),'lower') && isstrprop(S(k-1),'upper') ...
      && isstrprop(S(k-2),'upper')
    W(end+1) = ' ';
  end
  W(end+1) = S(k);
end


end


function S = unsnake(S)
%% UNSNAKE
if length(S) ~= (sum(isstrprop(S,'alphanum')) + length(strfind(S,'_')))
  return
end
S = strrep(S,'_',' ');
end % unsnake
