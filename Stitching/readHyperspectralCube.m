function hyperspectralCube = readHyperspectralCube( headerFileName )
%readHyperspectralCube - This function parses a ENVI header file associated
% with a hyperspectral image and returns the data structure containing the
% hyperspectral cube
%
% Syntax:  hyperspectralCube = readHyperspectralCube(headerFileName)
%
% Inputs:
%    headerFileName - ENVI hyperspectral image header file name
%
% Outputs:
%    hyperspectralCube  - Hyperspectral cube data structure (3D-Matrix)
%    containing the data described in the input header file
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required:
%
% Authors: Samuel Ortega, Himar Fabelo
% email address: sortega@iuma.ulpgc.es, hfabelo@iuma.ulpgc.es
% November 2017.

% Envi file name: the same name as the hdr name without filename extension:
 enviFileName   = headerFileName(1:end-4); 
%enviFileName   = [headerFileName(1:end-4), '.cue'];  % MODIFICATION FOR CUBERT EXPORT
% Parse the hdr file to extract the information:
fid = fopen(headerFileName); % Read the hdr file
while ~feof(fid) % Loop over the following until the end of the file is reached.
      line = fgets(fid); % Read file line by line
      % Extract the name of the feature and extract the information
      if strmatch('samples', line)
          digitIndex = regexp(line, '\d');
          value = line(digitIndex);
          samples = str2num(value);
      elseif strmatch('lines', line)
          digitIndex = regexp(line, '\d');
          value = line(digitIndex);
          lines = str2num(value);
      elseif strmatch('bands', line)
          digitIndex = regexp(line, '\d');
          value = line(digitIndex);
          bands = str2num(value);
      elseif strmatch('header offset', line)
          digitIndex = regexp(line, '\d');
          value = line(digitIndex);
          offset = str2num(value);     
      elseif strmatch('data type', line)
          digitIndex = regexp(line, '\d');
          value = line(digitIndex);
          dataType = str2num(value);
     elseif strmatch('interleave', line)
          if ~(isempty(strfind(line, 'bip')))
            interleave = 'bip';
          elseif ~(isempty(strfind(line, 'bil')))
            interleave = 'bil';
          elseif ~(isempty(strfind(line, 'bsq')))
            interleave = 'bsq';
          end;
     elseif strmatch('byte order', line)
          digitIndex = regexp(line, '\d');
          value = line(digitIndex);
          byteOrder = str2num(value);
      end;
end
fclose(fid);

% Adapt some data for the MATLAB multibandread function:
% Byte Order:
if byteOrder == 0
  byteOrderMATLAB = 'ieee-le';
else
  byteOrderMATLAB = 'ieee-be';
end;

% Data Type:
switch dataType
    case 1
        dataTypeMATLAB = 'int8'; 
    case 2
        dataTypeMATLAB = 'int16';
    case 3
        dataTypeMATLAB = 'int32';
    case 4
        dataTypeMATLAB = 'float';
    case 12
        dataTypeMATLAB = 'uint16';     
    otherwise
        dataTypeMATLAB = 'int8';
end;

% TODO: Replace multibandread using an own function
hyperspectralCube = multibandread(enviFileName,[lines,samples,bands],dataTypeMATLAB,offset,interleave,byteOrderMATLAB);

end

