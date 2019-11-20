function str = xmlwrite_octave(fname, dom)
   [folder, name, ext] = fileparts(mfilename('fullpath'));
   javaaddpath([folder '\xerces-2_11_0\xercesImpl.jar']);
   javaaddpath([folder '\xerces-2_11_0\xml-apis.jar']);
   jfile = javaObject ("java.io.File", fname);
   jos = javaObject ("java.io.FileOutputStream", jfile);
   ## Check the validity of the DOM document
   unwind_protect
    doc_classes = {"org.apache.xerces.dom.DeferredDocumentImpl", ...
                   "org.apache.xerces.dom.DocumentImpl"};
    if (! any (strcmp (class (dom), doc_classes)))
      error ("xmlwrite: DOM must be a java DOM document object")
    endif

    try
      jfmt = javaObject ("org.apache.xml.serialize.OutputFormat", dom);
      jfmt.setIndenting (1);
      serializer = javaObject ("org.apache.xml.serialize.XMLSerializer", ...
                               jos, jfmt);
    catch
      disp (lasterr ());
      error ("xmlwrite: couldn't load Xerces serializer object")
    end_try_catch

    try
      serializer.serialize (dom);
    catch
      disp (lasterr ());
      error ("xmlwrite: couldn't serialize document")
    end_try_catch
    
  unwind_protect_cleanup
   jos.close ();
  end_unwind_protect
endfunction


