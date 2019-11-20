function xDoc = xmlread_octave(filename)

[folder, name, ext] = fileparts(mfilename('fullpath'));

javaaddpath([folder '\xerces-2_11_0\xercesImpl.jar']);
javaaddpath([folder '\xerces-2_11_0\xml-apis.jar']);
try
   % search for needed java libraries and add own jar's to
   % pathn if not already there
   %jpath = javaclasspath('-all');
   
   %ind=strfind(lower(jpath),lower('xercesImpl.jar'));
   
   %if ( isempty(jpath) | min(cellfun(@isempty, ind)) == 1)
   %    javaaddpath([fileparts(mfilename('fullpath')) '\xercesImpl.jar']);
   %end
   %ind=strfind(lower(jpath),lower('xml-apis.jar'));
   %if ( isempty(jpath) | min(cellfun(@isempty, ind)) == 1)
   %    javaaddpath([fileparts(mfilename('fullpath')) '\xml-apis.jar']);
   %end
  
   parser = javaObject('org.apache.xerces.parsers.DOMParser');
   parser.parse(filename);
   xDoc = parser.getDocument;
catch
   disp(lasterr());
   error('Failed to read XML file %s with xerces',filename);
end

