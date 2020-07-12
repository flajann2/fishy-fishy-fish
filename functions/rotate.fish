function rotate -d "rotate an image"
    set pic $arv[1]
    set ang $stb[2]
    echo "Rotating $pic by $ang degrees"
    convert $pic -rotate $ang $pic
end
