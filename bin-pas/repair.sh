install_name_tool -change @rpath/SDL2.framework/Versions/A/SDL2 @loader_path/SDL2 kys_pig3
install_name_tool -change @rpath/SDL2_image.framework/Versions/A/SDL2_image @loader_path/SDL2_image kys_pig3
install_name_tool -change @rpath/SDL2_ttf.framework/Versions/A/SDL2_ttf @loader_path/SDL2_ttf kys_pig3

-install_name_tool -change @rpath/SDL2.framework/Versions/A/SDL2 @loader_path/SDL2 SDL2_ttf
-install_name_tool -change @rpath/SDL2.framework/Versions/A/SDL2 @loader_path/SDL2 SDL2_image
-install_name_tool -change @rpath/FreeType.framework/Versions/A/FreeType @loader_path/FreeType SDL2_ttf
strip kys_pig3