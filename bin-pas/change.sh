install_name_tool -change @loader_path/libavutil.54.dylib @loader_path/libavutil.dylib $1
install_name_tool -change @loader_path/libavcodec.56.dylib @loader_path/libavcodec.dylib $1
install_name_tool -change @loader_path/libswresample.1.dylib @loader_path/libswresample.dylib $1 
install_name_tool -change @loader_path/libavformat.56.dylib @loader_path/libavformat.dylib $1
