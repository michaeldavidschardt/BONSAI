//SPDX-License-Identifier: Unlicense

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./base64.sol";

//fix trait picking, fix colors

contract CryptoBonsai is ERC721Enumerable, Ownable {

    uint256 public maxSupply = 5000;
    uint256 public price = 0.01 ether; //change to 0.025 for mint
    uint256 public numTokensMinted;
    uint256 public maxPerAddress = 100; //change to 20 for mint
    uint256 public maxMint = 100; //change to 20 for mint

    // bool public allSalesPaused = true;
    bool public privateSaleIsActive = true;
    //bool public founderMints = true;

    mapping(address => uint256) private _mintPerAddress;
    mapping(address => bool)    private _whiteList;
    mapping(address => uint256) private _whiteListPurchases;
    mapping(address => uint256) private _whiteListLimit;
    mapping(address => bool)    private _founderList;
    //mapping(address => uint256) private _founderPurchases;
    mapping(address => uint256) private _founderLimit;

    constructor() ERC721("BONSAIVERSE", "BNSI") Ownable() {}

    string[7] private branchColors = ["#45283c","#663931","#b18354","#2b483f","#ab8db7","#ded7c6","#3f3e48"];
    string[7] private branchColorNames = ["Manzanita","Brown","Light Brown","Dark Green","Lavender","Bone","Dark"];
    string[5] private potColors = ["#663931","#6f252c","#2a2a71","#595652","#2e3d20"];
    string[5] private potColorNames = ["Brown","Dark Red","Blue","Grey","Green"];
    string[5] private soilColors = ["#2c2c64","#90765b","#557a33","#827672","#692c21"];
    string[5] private soilColorNames = ["Blue Grass","Tan Pebbles","Grass","Dark","Red Clay"];
    string[8] private leafColors = ["#A79AFF", "#FFABAB", "#E7FFAC", "#AFCBFF", "#7B9218", "#364511", "#39553F", "#C36F31"];
    string[8] private leafColorNames = ["Lilac", "Coral", "Sage", "Ice Blue", "Fresh Green", "Forrest Green", "Evergreen Green", "Light Brown"];
    string[39] private allColors = ["#EAFB00","#F0CF61","#0E38B1","#EF3E4A","#FEDAC2","#B0D8DC","#B6CAC0","#C02A1B","#1FC8A9","#C886A2","#F9BDBD","#FEDCCC","#EBB9D4","#F2CB6C","#FF8FA4","#343B3F","#FF89B5","#D1BDFF","#9A008A","#7B76A6","#FB5408","#0B64FE","#FAAD58","#FF8B8B","#F2F2F2","#FFD3C2","#FDB90B","#FCA59B","#CDCDD0"];
    string[39] private allColorNames = ["Laser Lemon","Arylide Yellow","Egyptian Blue","Carmine Pink","Peach Puff","Pale Aqua","Powder Ash","Thunderbird","Topaz","Lipstick Pink","Tea Rose","Peach Schnapps","Pink Flare","Sand","Pink Sherbet","Tuna","Rosa","Melrose","Dark Magenta","Greyish Purple","International Orange","Bright Blue","Pale Orange","Geraldine","Porcelain","Light Aprico","Golden","Sweet Pink","Grey Goose"];
    string[6] private bgAccessories = ['','<path d="M40 60h40v-20h50v20h100v20h-200zM30 230h40v20h-40zM380 250h40v-10h60v20h-100zM370 70h40v-20h30v10h20v10h10v10h10v10h-110z" fill="#cbdbfc"/><path d="M30 50h10v-10h20v10h10v-20h10v-10h10v-10h30v10h10v10h10v20h10v-10h20v10h10v10h10v-10h20v10h20v10h-60v-10h-40v-20h-50v20h-30v10h-10v10h-10zM350 70h20v-10h30v-10h10v-10h20v10h10v10h10v-10h10v10h10v10h10v10h10v10h-10v-10h-10v-10h-10v-10h-10v10h-10v-10h-10v-10h-10v10h-10v10h-40v10h-20zM40 220h10v10h20v10h10v10h-10v-10h-20v-10h-10zM390 250h20v-10h20v-10h20v10h-20v10h-20zM460 220h10v10h10v20h10v10h-10v-10h-10v-10h-10z" fill="#ffffff"/><path d="M10 80h10v-10h10v10h200v-10h20v10h10v10h-250zM20 240h10v10h60v10h-60v-10h-10zM370 260h60v-10h10v10h20v-10h10v10h30v10h-130M350 80h20v10h50v-10h10v10h20v-10h20v10h10v10h-120v-10h-10z" fill="#a6b4d2"/>','<path d="M0 180h20v-10h20v-10h20v-10h20v-10h20v-10h10v-10h20v-10h20v-10h10v-10h10v-10h20v-10h10v-10h10v-10h10v-10h20v-10h30v10h10v10h10v10h20v10h10v10h10v10h10v10h10v10h20v10h20v10h10v10h10v10h10v10h20v10h20v10h20v10h20v160h-500z" fill="#5b6ee1"/><path d="M130 110h20v-10h10v-10h10v-10h20v-10h10v-10h10v-10h10v-10h20v-10h30v10h10v10h10v10h20v10h10v10h10v10h10v10h10v10h20v10h20v10h-20v-10h-40v-10h-20v-10h-10v10h-10v10h-20v-10h-10v-10h-10v-10h-20v10h-20v-10h-20v10h-30v10h-10v10h-20z" fill="#cbdbfc"/><path d="M220 70h10v-10h10v-10h20v10h-10v10h-10v10h-20zM260 80h10v10h10v10h-10v-10h-10zM270 50h10v10h10v10h10v10h-10v-10h-10v-10h-10z" fill="#5b6ee1"/><path d="M0 290h10v-10h20v-10h20v-10h10v-10h30v10h10v10h20v10h10v10h10v10h10v-10h10v-10h10v-10h20v-10h20v10h20v10h10v10h70v-10h20v-10h20v-10h20v10h20v10h20v10h20v10h10v-10h10v-10h10v-10h10v-10h20v10h10v80h-500" fill="#3f3f74"/>','<path d="M0 100h50v10h-50zM60 90h30v30h-30zM100 100h30v10h-30zM140 100h10v10h-10zM70 130h10v40h-10zM70 40h10v40h-10zM100 80h10v-10h10v-10h10v-10h20v-10h30v-10h50v-10h70v10h50v10h40v10h30v10h20v10h20v10h20v10h10v10h10v10h-10v-10h-10v-10h-20v-10h-20v-10h-20v-10h-30v-10h-40v-10h-50v-10h-70v10h-50v10h-30v10h-20v10h-10v10h-10v10h-10z" fill="#ffffff"/><path d="M100 90h10v-10h10v-10h10v-10h20v-10h30v-10h50v-10h70v10h50v10h40v10h30v10h20v10h20v10h20v10h10v10h10v10h-10v-10h-10v-10h-20v-10h-20v-10h-20v-10h-30v-10h-40v-10h-50v-10h-70v10h-50v10h-30v10h-20v10h-10v10h-10v10h-10zM40 70h10v10h10v10h-10v10h10v10h-10v10h10v10h-10v10h-10v-10h10v-10h-10v-10h10v-10h-10v-10h10v-10h-10M60 70h10v10h10v-10h10v10h10v-10h10v10h-10v10h-10v-10h-10v10h-10v-10h-10zM90 100h10v10h10v10h-10v10h10v10h-10v-10h-10v-10h10v-10h-10zM60 130h10v-10h10v10h10v10h-10v-10h-10v10h-10z" fill="#cbdbfc"/>','<path d="m130 90h10v-10h20v-10h20v-10h20v-10h100v10h20v10h20v10h20v10h10v10h-240z" fill="#ffbc00"/><path d="m110 110h280v10h10v20h-300v-20h10zM90 150h320v10h10v20h-340v-20h10z" fill-opacity=".85" fill="#ffbc00"/><path d="m70 190h360v30h-360zM70 230h360v20h-360z" fill-opacity=".70" fill="#ffbc00"/><path d="m80 260h340v20h-340zM90 290h320v10h-320z" fill-opacity=".55" fill="#ffbc00"/><path d="m100 310h300v10h-300zM110 330h280v10h-280z" fill-opacity=".4" fill="#ffbc00"/>', '<path d="M20 100h20v-20h10v20h20v10h-20v20h-10v-20h-20zM50 290h10v-10h10v-10h10v10h10v10h10v10h-10v10h-10v10h-10v-10h-10v-10h-10zM150 50h10v-10h10v-20h10v20h10v10h20v10h-20v10h-10v20h-10v-20h-10v-10h-20v-10zM430 190h10v-10h10v-10h10v10h10v10h10v10h-10v10h-10v10h-10v-10h-10v-10h-10zM390 280h10v-10h10v-20h10v20h10v10h20v10h-20v10h-10v20h-10v-20h-10v-10h-20v-10zM390 20h40v110h-40v-10h10v-10h10v-10h10v-50h-10v-10h-10v-10h-10zM50 220h10v10h-10zM20 160h10v10h-10zM100 100h10v10h-10zM260 40h10v10h-10zM330 80h10v10h-10zM50 20h10v10h-10zM460 320h10v10h-10z" fill-opacity="0.6" fill="#ffffff"/><path d="M30 100h10v-10h10v10h10v10h-10v10h-10v-10h-10zM60 290h10v-10h10v10h10v10h-10v10h-10v-10h-10zM160 50h10v-10h10v10h10v10h-10v10h-10v-10h-10zM440 190h10v-10h10v10h10v10h-10v10h-10v-10h-10zM400 280h10v-10h10v10h10v10h-10v10h-10v-10h-10zM400 20h50v10h10v10h10v10h10v50h-10v10h-10v10h-10v10h-50v-10h10v-10h10v-10h10v-50h-10v-10h-10v-10h-10z" fill="#ffffff"/>'];
    string[6] private bgAccessoriesNames = ['','Clouds','Mt. Fuji','Comet','Sun', 'Stars'];
    string[6] private fgAccessories = ['','<path d="M0 350h500v150h-500z" fill="#714835"/><path d="M0 360h20v20h-10v20h-10zM30 360h360v20h10v20h-380v-20h10zM400 360h100v40h-90v-20h-10zM0 410h80v30h-10v20h-70zM90 410h380v30h10v20h-400v-20h10zM480 410h20v50h-10v-20h-10zM0 470h170v20h-10v10h-160zM180 470h240v20h10v10h-260v-10h10zM430 470h70v30h-60v-10h-10z" fill="#aa7459"/><path d="M10 360h10v20h-10v20h-10v-20h10zM40 360h80v10h-80zM380 360h10v20h10v20h-10v-20h-10zM410 360h90v10h-90zM0 410h80v30h-10v20h-10v-20h10v-20h-70zM100 410h370v30h10v20h-10v-20h-10v-20h-360zM490 410h10v10h-10zM0 470h170v20h-10v10h-10v-10h10v-10h-160M190 470h230v20h10v10h-10v-10h-10v-10h-220zM440 470h60v10h-60z" fill="#bb8166"/><path d="M30 360h10v20h-10v10h60v-10h20v10h10v10h-100v-20h10zM50 370h20v10h-20zM400 360h10v20h10v10h20v-10h20v10h40v10h-90v-20h-10zM380 390h10v10h-10zM480 370h20v10h-20zM0 450h60v10h-60zM10 430h40v10h-40zM90 410h10v30h-10v10h380v10h-390v-20h10zM110 430h30v10h-30zM370 430h80v10h-80zM480 410h10v30h10v20h-10v-20h-10zM0 480h50v10h-50zM80 490h50v10h-50zM180 470h10v20h-10v20h-10v-20h10zM200 490h30v10h-30zM250 480h80v10h-80zM430 470h10v20h10v10h-10v-10h-10M460 490h30v10h-30z" fill="#93654e"/>','<path d="M0 350h500v150h-500z" fill="#639bff"/><path d="M0 370h70v10h-70zM60 400h40v10h-40zM0 440h40v10h-40zM60 460h20v10h-20zM0 480h40v10h-40zM70 480h360v10h-360zM430 360h70v10h-70zM410 390h60v10h-60zM440 430h40v10h-40zM430 460h40v10h-40zM480 480h20v10h-20z" fill="#5b6ee1"/><path d="M100 340h300v30h10v40h10v40h10v30h-360v-30h10v-40h10v-40h10z" fill="#eec39a"/><path d="M100 360h300v10h-300zM90 390h320v20h-320zM80 430h340v20h-340zM70 470h360v10h-360z" fill="#d9a066"/><path d="M130 410h10v40h-10v30h-20v-30h10v-30h10zM240 440h20v40h-20zM360 410h10v10h10v30h10v30h-20v-30h-10z" fill="#a4794e"/>','<path d="M0 350h20v-10h20v-10h60v10h20v10h250v-20h50v10h30v10h30v-10h10v-10h10v170h-500z" fill="#d9a066"/> <path d="M0 350h20v-10h20v-10h30v10h-10v10h-10v10h-20v10h-20v10h-10zM0 430h20v-10h10v-10h40v10h10v10h10v10h10v10h-10v-10h-10v-10h-10v-10h-20v10h-10v10h-40zM90 480h20v-10h20v-10h40v10h20v10h20v10h-20v-10h-20v-10h-20v10h-20v10h-40zM350 480h20v-10h30v10h10v10h-10v-10h-20v10h-30zM350 440h20v-10h20v-10h30v-10h40v10h20v10h20v10h-20v-10h-20v-10h-20v10h-30v10h-20v10h-40zM170 440h160v10h-160zM450 360h20v-10h10v-10h10v-10h10v20h-10v10h-20v10h-20zM370 330h30v10h-10v10h-10v-10h-10z" fill="#b17d48"/>','<path d="M70 360h360v10h-20v10h20v10h-20v10h30v10h-20v10h20v10h-20v10h30v10h-20v10h20v10h-20v10h30v10h-420v-10h30v-10h-20v-10h20v-10h-20v-10h30v-10h-20v-10h20v-10h-20v-10h30v-10h-20v-10h20v-10h-20z" fill="#f4dcc5"/><path d="M100 370h300v30h10v40h10v40h-340v-40h10v-40h10z" fill="#ac3232"/><path d="M110 380h10v30h-10zM380 380h10v30h-10zM100 410h10v40h-10zM390 410h10v40h-10zM90 450h10v10h300v-10h10v20h-320z" fill="#df7126"/><path d="M130 410h10v10h-10zM360 410h10v10h-10zM120 420h10v20h240v-20h10v30h-260z" fill="#3f3f74"/>', '<path d="M30 350h30v10h-10v10h40v10h-10v10h-10v10h40v10h-10v20h-10v10h40v20h-10v20h-10v10h50v10h-50v-10h-50v-10h10v-20h10v-10h10v-10h-40v-10h10v-20h10v-10h-40v-10h10v-10h10v-10h-30v-10h10zM0 370h20v10h-10v10h-10zM0 400h30v10h-10v10h-10v20h-10zM0 450h10v-10h40v10h-10v10h-10v10h-10v20h-20zM20 490h40v10h-40zM100 350h20v20h-30v-10h10zM110 390h10v10h-10zM130 430 h10v-10h10v10h10v10h-30zM110 490h50v-30h10v-20h50v10h-10v40h50v-50h40v10h10v40h50v-30h-10v-20h-10v-10h10v10h50v20h10v20h10v10h50v-10h-10v-10h-10v-20h-10v-10h40v10h10v10h10v30h-30v10h-50v-10h-60v10h-50v-10h-50v10h-50v-10zM380 400h40v-10h-10v-10h-10v-10h-20v-20h10v10h10v10h30v-10h-10v-10h30v10h10v10h-30v10h10v10h10v10h-30v10h10v20h10v10h-40v-10h-10v-20h-10zM450 400h30v-10h-10v-10h-10v-10h30v-10h-10v-10h20v20h-10v10h10v20h-20v10h10v10h10v20h-20v-10h-10v-10h-10v-10h-10z" fill="#ffffff"/>'];
    string[6] private fgAccessoriesNames = ['','Hardwood Floor','Bamboo Raft','Sand Dunes','Rug', 'Checkered Floor'];
    string[9] private accessories = ['','<path d="M140 130 h10v-10h10v10h10v30h-10v10h-10v-10h-10zM120 230 h10v-10h10v10h10v30h-10v10h-10v-10h-10zM180 190 h10v-10h10v10h10v30h-10v10h-10v-10h-10zM270 160 h10v-10h10v10h10v30h-10v10h-10v-10h-10zM360 170 h10v-10h10v10h10v30h-10v10h-10v-10h-10zM340 240 h10v-10h10v10h10v30h-10v10h-10v-10h-10z" fill="#fbf236"/><path d="M150 120h10v10h10v30h-10v10h-10v-10h10v-30h-10zM130 220h10v10h10v30h-10v10h-10v-10h10v-30h-10zM190 180h10v10h10v30h-10v10h-10v-10h10v-30h-10zM280 150h10v10h10v30h-10v10h-10v-10h10v-30h-10zM370 160h10v10h10v30h-10v10h-10v-10h10v-30h-10zM350 230h10v10h10v30h-10v10h-10v-10h10v-30h-10z" fill="#c1b918"/>','<path d="M220 80h80v50h-80z" fill="#c8a98c"/><path d="M210 80h30v10h-10v10h-10v10h-10z M280 80h30v30h-10v-10h-10v-10h-10zM250 110h20v10h10v20h-40v-20h10z" fill="#433431"/><path d="M250 140h20v10h-20z" fill="#d85780"/><path d="M250 120h20v-20h10v20h-10v10h-20zM230 100h10v20h-10z" fill="#222034"/><path d="M240 100h10v20h-10zM280 100h10v20h-10z" fill="#ffffff"/>','<path d="M180 220h30v-20h60v20h10v-20h60v60h-60v-30h-10v30h-60v-30h-20v20h-10z" fill="#639bff"/> <path d="M220 210h20v40h-20zM290 210h20v40h-20z" fill="#ffffff"/> <path d="M240 210h20v40h-20zM310 210h20v40h-20z" fill="#000000"/>','<path d="M200 60h10v10h10v20h10v10h10v-10h10v-20h10v-10h10v10h10v20h10v10h10v-10h10v-20h10v-10h10v70h-10v20h-10v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-30h-20v20h-20z" fill="#76428a"/><path d="M200 60h10v50h10v20h-20zM230 100h10v10h-10zM240 90h10v10h-10zM250 70h10v20h-10zM290 100h10v10h-10zM300 90h10v10h-10zM310 70h10v20h-10zM240 130h40v10h-10v10h-20v10h-10zM300 130h20v20h-10v-10h-10z" fill-opacity="0.15" fill="#000000"/>','<path d="M150 200h240v20h-10v10h-10v10h-10v10h-60v-10h-10v-10h-10v-10h-20v10h-10v10h-10v10h-60v-10h-10v-10h-10v-10h-10z" fill="#222034"/><path d="M200 230h10v-10h10v-10h10v10h-10v10h-10v10h-10zM220 230h10v-10h10v-10h10v10h-10v10h-10v10h-10zM320 230h10v-10h10v-10h10v10h-10v10h-10v10h-10zM340 230h10v-10h10v-10h10v10h-10v10h-10v10h-10z" fill="#ffffff"/>','<path d="M200 110h10v-10h50v-30h40v60h-20v10h-10v10h-20v-10h-10v-30h-20v20h-10v-10h-10z" fill="#ffffff"/> <path d="M250 50h10v10h10v10h-10v10h-10z" fill="#dc3636"/> <path d="M270 80h10v10h-10zM290 80h10v10h-10z" fill="#000000"/> <path d="M300 90h20v10h-10v10h-10z" fill="#d9a066"/>', '<path d="m110 140h10v-10h20v-10h20v-10h20v-10h20v-10h20v-10h20v-10h20v10h20v10h20v10h20v10h20v10h20v10h20v10h10v10h-280z" fill="#b5895c"/><path d="m180 120h10v10h10v-10h10v-10h-10v-10h10v10h10v-10h10v-10h10v-10h10v-10h10v10h20v10h20v10h20v10h20v10h20v20h-40v-10h20v-10h-20v10h-20v10h-70v-10h-20v10h-20v-10h-10v10h-20v-10h20z" fill="#d9a066"/><path d="m240 100h20v-10h20v10h-20v10h-20zM260 120h20v-10h20v10h-20v10h-20z" fill="#b5895c"/><path d="m110 150h270v10h-270z" fill-opacity="0.3" fill="#000000"/>', '<path d="M110 240h10v40h-10zM110 300h10v40h-10zM160 260h10v40h-10zM110 300h10v40h-10zM210 230h10v40h-10zM320 270h10v40h-10zM380 230h10v40h-10zM380 290h10v40h-10z" fill="#9d97a0"/> <path d="M120 230h10v10h10v10h-20zM120 270h20v10h-20zM120 290h10v10h10v10h-20zM120 330h20v10h-20zM120 350h10v10h-10z M170 250h10v10h10v10h-20zM330 300h20v10h-20zM330 320h10v10h-10zM330 260h10v10h10v10h-20zM220 260h20v10h-20zM220 280h10v10h-10zM220 220h10v10h10v10h-20zM170 290h20v10h-20zM170 310h10v10h-10zM390 220h10v10h10v10h-20zM390 260h20v10h-20zM390 280h10v10h10v10h-20zM390 320h20v10h-20zM390 340h10v10h-10z" fill="#847e87"/> <path d="M130 250h10v20h-10zM120 280h10v10h-10zM130 310h10v20h-10zM120 340h10v10h-10z M180 270h10v20h-10zM170 300h10v10h-10zM170 240h10v10h-10zM220 210h10v10h-10zM230 240h10v20h-10zM220 270h10v10h-10zM330 250h10v10h-10zM340 280h10v20h-10zM330 310h10v10h-10zM390 210h10v10h-10zM400 240h10v20h-10zM390 270h10v10h-10zM400 300h10v20h-10zM390 330h10v10h-10z" fill="#696a6a"/>'];
    string[9] private accessoriesNames = ['','Lemons','Nellie','Noun Glasses','Purple Party Hat','Deal With It','Chicken Fren', 'Rice Hat', 'chains'];
    string[5] private potAccessories = ['','<path d="M140 360h10v30h10v-10h10v10h10v-30h10v30h-10v10h-10v-10h-10v10h-10v-10h-10zM200 380h10v-10h10v10h10v10h-10v-10h-10v10h-10zM200 390h30v20h-10v-10h-10v10h-10zM240 380h10v-10h20v10h-20v20h10v-10h20v10h-10v10h-20v-10h-10zM290 380h10v-10h10v10h10v-10h10v10h10v30h-10v-30h-10v10h-10v-10h-10v30h-10zM350 360h10v40h-10z" fill-opacity="0.4" fill="#ffffff"/>','<path d="M140 390h10v10h10v10h10v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h10v-10h10v-10h10v10h-10v10h-10v10h-10v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-10v-10h-10v-10h-10z" fill="#222034"/><path d="M140 380h10v10h10v10h10v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h10v-10h10v-10h10v10h-10v10h-10v10h-10v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-10v-10h-10v-10h-10z" fill="#d25c0b"/><path d="M140 370h10v10h10v10h10v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h10v-10h10v-10h10v10h-10v10h-10v10h-10v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-10v-10h-10v-10h-10zM130 380h10v10h-10zM360 380h10v10h-10z" fill="#fbb236"/>','<path d="M140 390h10v10h10v10h10v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h10v-10h10v-10h10v10h-10v10h-10v10h-10v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-10v-10h-10v-10h-10z" fill="#222034"/><path d="M140 380h10v10h10v10h10v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h10v-10h10v-10h10v10h-10v10h-10v10h-10v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-10v-10h-10v-10h-10z" fill="#d25c0b"/><path d="M140 370h10v10h10v10h10v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h20v-10h10v-10h20v10h10v10h10v-10h10v-10h10v10h-10v10h-10v10h-10v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-20v-10h-10v-10h-20v10h-10v10h-10v-10h-10v-10h-10zM130 380h10v10h-10zM360 380h10v10h-10z" fill="#fbb236"/>','<path d="M160 300h70v10h-20v10h-10v10h10v10h10v10h60v-10h10v-10h10v-10h-10v-10h-10v-10h60v10h20v10h10v10h10v10h10v20h-10v50h10v20h-10v10h-10v10h-20v10h-30v10h-140v-10h-30v-10h-20v-10h-10v-10h-10v-20h10v-50h-10v-20h10v-10h10v-10h10v-10h20z" fill="#dd8e36"/><path d="M110 340h10v-10h10v-10h10v-10h20v-10h30v10h-10v10h-20v10h-10v20h10v10h20v10h30v10h110v10h-140v-10h-30v-10h-20v-10h-20zM110 410h20v10h20v10h30v10h120v10h-120v-10h-30v-10h-20v-10h-10v10h10v10h20v10h30v10h140v10h-140v-10h-30v-10h-20v-10h-10v-10h-10zM210 300h20v10h-20v10h-10v10h10v10h10v10h60v-10h10v-10h10v-10h-10v-10h-10v-10h10v10h10v10h10v10h-10v10h-10v10h-10v10h-60v-10h-10v-10h-10v-10h-10v-10h10v-10h10z" fill="#d27207"/><path d="M120 360h10v10h20v10h30v10h140v-10h30v-10h20v-10h10v10h-10v10h-20v10h-30v10h-140v-10h-30v-10h-20v-10h-10z" fill="#dd2323"/><path d="M120 380h10v10h20v10h30v10h140v-10h30v-10h20v-10h10v20h-10v10h-20v10h-30v10h-140v-10h-30v-10h-20v-10h-10z" fill="#663931"/><path d="M120 370h10v10h20v10h30v10h140v-10h30v-10h20v-10h10v10h-10v10h-20v20h-10v-10h-20v10h-10v10h-10v-10h-50v10h-20v-10h-20v10h-10v-10h-20v-10h-10v10h-10v-10h-10v-10h-20v-10h-10z" fill="#f9be57"/><path d="M120 400h10v10h20v10h30v10h140v-10h30v-10h20v-10h10v10h-10v10h-20v10h-30v10h-140v-10h-30v-10h-20v-10h-10z" fill="#6abe30"/><path d="M160 330h10v10h-10zM190 300h10v10h-10zM180 350h10v10h-10zM200 340h10v10h-10zM220 370h10v10h-10zM250 360h10v10h-10zM290 370h10v10h-10zM300 340h10v10h-10zM330 360h10v10h-10zM360 340h10v10h-10zM340 320h10v10h-10zM310 300h10v10h-10z" fill="#eec39a"/>'];
    string[5] private potAccessoriesNames = ['','WAGMI Light','Wavey Blue','Wavey Orange','Borgor'];

    struct cryptoBonsai {
        uint256 berryColor;
        uint256 leafColor;
        uint256 backgroundColor;
        uint256 potColor;
        uint256 branchColor;
        //uint256 soilColor;
        uint256 bgAccessories;
        uint256 fgAccessories;
        uint256 accessories;
        uint potAccessories;
    }

    function randomBonsai(uint256 tokenId) internal view returns (cryptoBonsai memory) {
        cryptoBonsai memory bonsai;

        bonsai.berryColor = getAColor(tokenId, "FLOWER");
        bonsai.leafColor = getLeafColor(tokenId, "LEAF");
        //bonsai.soilColor = getSoilColor(tokenId, "SOIL");
        bonsai.branchColor = getBranchColor(tokenId, "BRANCH");
        bonsai.backgroundColor = getAColor(tokenId, "BGC");
        bonsai.potColor = getPotColor(tokenId, "POT");
        bonsai.bgAccessories = getBgAcc(tokenId);
        bonsai.fgAccessories = getFgAcc(tokenId);
        bonsai.accessories = getAccessories(tokenId);
        bonsai.potAccessories = getPotAccessories(tokenId);

        return bonsai;
    }
    
    function getTraits(cryptoBonsai memory bonsai) internal view returns (string memory) {
        string[20] memory parts;
        
        parts[0] = ', "attributes": [{"trait_type": "Background Color","value": "';
        parts[1] = allColorNames[bonsai.backgroundColor];
        parts[2] = '"}, {"trait_type": "Flowers","value": "';
        parts[3] = allColorNames[bonsai.berryColor];
        parts[5] = '"}, {"trait_type": "Leaf Color","value": "';
        parts[6] = leafColorNames[bonsai.leafColor];
        parts[7] = '"}, {"trait_type": "Branch","value": "';
        parts[8] = branchColorNames[bonsai.branchColor];
        parts[9] = '"}, {"trait_type": "Pot Color","value": "';
        parts[10] = potColorNames[bonsai.potColor];
        parts[11] = '"}, {"trait_type": "Accessories","value": "';
        parts[12] = accessoriesNames[bonsai.accessories];
        parts[13] = '"}, {"trait_type": "Accessories","value": "';
        parts[14] = fgAccessoriesNames[bonsai.fgAccessories];
        parts[15] = '"}, {"trait_type": "Accessories","value": "';
        parts[16] = bgAccessoriesNames[bonsai.bgAccessories];
        parts[17] = '"}, {"trait_type": "Accessories","value": "';
        parts[18] = potAccessoriesNames[bonsai.potAccessories];
        parts[19] = '"}] ';
        
        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
                      output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15]));
                      output = string(abi.encodePacked(output, parts[16], parts[17], parts[18], parts[19]));
        return output;
    }

    /* UTILITY FUNCTIONS FOR PICKING RANDOM TRAITS */
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    
    function getNum(uint256 tokenId, string memory keyPrefix, uint256 minNum, uint256 maxNum) internal view returns (uint256) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId), minNum, maxNum, msg.sender, block.timestamp, block.difficulty)));
        uint256 num = rand % (maxNum - minNum + 1) + minNum;
        return num;
    }
    
    function getAColor(uint256 tokenId, string memory seed) internal view returns (uint256) {
        return getNum(tokenId, seed, 0, 10);
    }

    function getPotColor(uint256 tokenId, string memory seed) internal view returns (uint256) {
        return getNum(tokenId, seed, 0, 4);
    }

    // function getSoilColor(uint256 tokenId, string memory seed) internal view returns (uint256) {
    //     return getNum(tokenId, seed, 0, 3);
    // }

    function getBranchColor(uint256 tokenId, string memory seed) internal view returns (uint256) {
        return getNum(tokenId, seed, 0, 5);
    }

    function getLeafColor(uint256 tokenId, string memory seed) internal view returns (uint256) {
        return getNum(tokenId, seed, 0, 6);
    }
    
    function getFgAcc(uint256 tokenId) internal pure returns (uint256) {
        uint256 rand = random(string(abi.encodePacked("BACKGROUND TYPE", Strings.toString(tokenId))));
        uint256 gt = rand % 101; 
        uint256 fgAcc = 0;

        if (gt > 50 && gt <= 60) { fgAcc = 1; }
        if (gt > 61 && gt <= 70) { fgAcc = 2; }
        if (gt > 71 && gt <= 80) { fgAcc = 3; }
        if (gt > 81 && gt <= 90) { fgAcc = 4; }
        if (gt > 91 && gt <= 95) { fgAcc = 5; }

        return fgAcc;
    }

    function getAccessories(uint256 tokenId) internal pure returns (uint256) {
        uint256 rand = random(string(abi.encodePacked("Accessories", Strings.toString(tokenId))));
        uint256 gt = rand % 101; 
        uint256 Accessories = 0;

        if (gt > 30 && gt <= 39) { Accessories = 1; }
        if (gt > 40 && gt <= 50) { Accessories = 2; }
        if (gt > 51 && gt <= 60) { Accessories = 3; }
        if (gt > 61 && gt <= 70) { Accessories = 4; }
        if (gt > 71 && gt <= 80) { Accessories = 5; }
        if (gt > 81 && gt <= 90) { Accessories = 6; }
        if (gt > 91 && gt <= 95) { Accessories = 7; }
        if (gt > 96 && gt <= 100) { Accessories = 8; }

        return Accessories;
    }

    function getPotAccessories(uint256 tokenId) internal pure returns (uint256) {
        uint256 rand = random(string(abi.encodePacked("potAccessories", Strings.toString(tokenId))));
        uint256 gt = rand % 101; 
        uint256 potAcc = 0;

        if (gt > 50 && gt <= 60) { potAcc = 1; }
        if (gt > 61 && gt <= 70) { potAcc = 2; }
        if (gt > 71 && gt <= 80) { potAcc = 3; }

        return potAcc;
    }

    function getBgAcc(uint256 tokenId) internal pure returns (uint256) {
        uint256 rand = random(string(abi.encodePacked("potAccessories", Strings.toString(tokenId))));
        uint256 gt = rand % 101; 
        uint256 BgAcc = 0;

        if (gt > 50 && gt <= 60) { BgAcc = 1; }
        if (gt > 61 && gt <= 70) { BgAcc = 2; }
        if (gt > 71 && gt <= 85) { BgAcc = 3; }
        if (gt > 86 && gt <= 92) { BgAcc = 4; }
        if (gt > 93 && gt <= 100) { BgAcc = 5; }

        return BgAcc;
    }
    
    /* SVG BUILDING FUNCTIONS */

    function getBonsaiSVG(cryptoBonsai memory bonsai) internal view returns (string memory) {
        string[25] memory parts;

        parts[0] = '<svg viewBox="0 0 500 500" fill="none" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">';
        parts[1] = '<path d="M0 0h500v500h-500z" fill="';
        parts[2] = allColors[bonsai.backgroundColor];
        parts[3] = '"/>';
        parts[4] = '<path d="M0 350h500v150h-500z" fill="#222034"/>';
        parts[5] = bgAccessories[bonsai.bgAccessories];
        parts[6] = fgAccessories[bonsai.fgAccessories];
        parts[7] = '<path d="M160 110h20v10h10v10h30v-20h20v30h10v10h20v-10h10v-10h20v10h10v10h10v-20h20v20h40v10h10v10h10v10h10v20h-10v10h-10v10h-10v10h-20v20h-40v-30h10v-10h10v-10h10v-10h-10v-10h-10v10h-10v10h-10v10h-30v-10h-10v-10h-40v-10h-10v-10h-30v10h10v20h10v10h10v20h-10v10h-10v10h-20v-10h-20v10h-20v-10h-10v-10h-10v10h-10v-10h-10v-20h10v-10h10v-20h-10v-10h-10v-20h10v-10h10v-10h30v-10h10z" fill="';
        parts[8] = leafColors[bonsai.leafColor];
        parts[9] = '"/><path d="M170 110h10v10h-10zM180 120h10v10h-10zM160 120h10v10h-10zM150 130h10v10h-10zM130 130h10v10h-10zM170 130h10v10h-10zM200 130h10v10h-10zM230 130h10v10h-10zM240 140h10v10h-10zM250 150h10v10h-10zM310 150h10v10h-10zM300 140h10v10h-10zM290 130h10v10h-10zM320 140h10v10h-10zM330 160h10v10h-10zM340 150h10v10h-10zM360 150h20v10h-20zM380 160h10v10h-10zM390 170h10v10h-10zM400 180h10v10h-10zM390 190h10v10h-10z" fill-opacity="0.15" fill="#ffffff"/><path d="M110 140h10v20h-10zM100 160h10v10h-10zM110 170h10v10h-10zM120 180h10v10h-10zM130 190h10v10h-10zM110 200h20v10h-20zM100 210h10v10h20v10h-10v10h-10v-10h-10zM130 230h20v10h10v10h-20v-10h-10zM180 240h10v10h-10zM170 230h10v10h-10zM160 220h10v10h-10zM150 210h10v10h-10zM160 200h10v10h-10zM150 190h10v10h-10zM170 210h10v10h-10zM180 220h10v10h-10zM190 210h10v10h-10zM200 200h10v10h-10zM210 210h10v20h-10zM200 230h10v10h-10zM190 180h10v10h-10zM180 170h10v10h-10zM150 160h10v10h-10zM140 150h10v10h-10zM180 150h10v10h-10zM170 140h10v10h-10zM210 160h10v10h-10zM230 170h10v10h-10zM240 180h10v10h-10zM250 170h10v10h-10zM260 180h10v10h-10zM270 190h10v10h-10zM280 200h10v10h-10zM290 190h10v10h-10zM300 200h10v10h-10zM310 190h10v10h-10zM280 170h10v10h-10zM270 160h10v10h-10zM350 180h10v10h-10zM360 190h10v10h-10zM350 200h10v10h-10zM340 210h10v10h-10zM320 220h10v10h10v20h-20zM360 220h20v10h-20zM380 210h10v10h-10zM160 170h10v10h-10z" fill-opacity="0.2" fill="#000000"/>'; //leaf base
        parts[10] = '<path d="M120 150h10v10h10v10h-20zM120 210h20v20h-10v-10h-10zM180 190h20v10h-10v10h-10zM160 160h10v-10h10v20h-20zM180 130h20v20h-10v-10h-10zM220   110h20v20h-10v-10h-10zM220 160h10v-10h10v20h-20zM280 150h10v10h10v10h-20zM300 180h10v-10h10v20h-20zM320 130h20v20h-10v-10h-10zM360 170h20v20h-10v-10h-10zM350 230h10v20h-20v-10h10z" fill="';
        parts[11] = allColors[bonsai.berryColor];
        parts[12] = '"/> <path d="M130 210h10v10h-10zM170 150h10v10h-10zM190 130h10v10h-10zM230 110h10v10h-10zM230 150h10v10h-10zM310 170h10v10h-10zM330 130h10v10h-10zM370 170h10v10h-10z" fill-opacity="0.25" fill="#ffffff"/> <path d="M120 160h10v10h-10zM130 220h10v10h-10zM180 200h10v10h-10zM160 160h10v10h-10zM220 160h10v10h-10zM280 160h10v10h-10zM340 240h10v10h-10z" fill-opacity="0.2" fill="#000000"/>';//berry shadows
        parts[13] = '<path d="M160 300h180v10h10v10h10v10h10v10h10v60h-10v10h-10v10h-10v10h-10v10h-180v-10h-10v-10h-10v-10h-10v-10h-10v-60h10v-10h10v-10h10v-10h10z" fill="';
        parts[14] = potColors[bonsai.potColor];
        parts[15] = '"/> <path d="M170 310h10v10h10v20h10v10h10v10h-20v-10h-10v-20h-10zM210 360h80v10h-80zM290 350h10v10h-10zM300 340h10v10h-10zM310 320h10v20h-10zM320 310h10v10h-10zM140 340h10v20h10v20h10v10h20v10h10v-10h10v10h10v-10h10v10h10v-10h10v10h10v-10h10v10h10v-10h10v10h10v10h10v10h10v-10h10v-10h20v10h-10v10h-10v10h-160v-10h-10v-10h-10v-10h-10v-10h-10v-40h10zM350 390h10v10h-10zM360 380h10v10h-10zM310 400h10v10h-10zM300 390h10v10h-10zM320 390h10v10h-10z" fill-opacity="0.09" fill="#ffffff"/> <path d="M160 320h10v10h10v20h10v10h20v10h80v-10h10v-10h20v10h10v10h10v10h10v-10h10v20h-10v10h-20v-10h-10v10h-10v-10h-10v10h-10v-10h-10v10h-10v-10h-10v10h-10v-10h-10v10h-10v-10h-10v10h-10v-10h-10v10h-10v-10h-20v-10h-10v-20h-10v-30h10zM300 400h10v10h-10zM310 360h10v10h-10zM320 400h10v10h-10zM320 340h10v10h-10zM330 350h10v10h-10zM340 360h10v10h-10zM350 350h10v10h-10zM340 340h10v10h-10zM330 330h10v10h-10zM310 410h10v10h-10z" fill-opacity="0.2" fill="#ffffff"/> <path d="M310 340h10v10h-10zM320 350h10v10h-10zM330 360h10v10h-10zM340 370h10v10h-10zM350 360h10v-10h10v30h-10v-10h-10zM340 350h10v10h-10zM330 340h10v10h-10zM320 320h20v10h-10v10h-10zM340 330h10v10h-10zM350 340h10v10h-10z" fill-opacity="0.35" fill="#ffffff"/>';//pot highlights
        parts[16] = '<path d="M190 170h30v10h10v10h10v10h20v10h10v10h10v20h10v-10h10v-20h10v-10h10v-10h10v-10h10v10h10v10h-10v10h-10v10h-10v20h-10v20h-10v10h-10v10h-10v40h10v10h-10v10h-60v-10h-10v-10h10v-10h10v-10h10v-30h10v-10h10v-20h-10v-10h-10v-10h-10v-10h-10v-10h-10v-10h-10v-10h-10z" fill="';
        parts[17] = branchColors[bonsai.branchColor];
        parts[18] = '"/> <path d="M210 170h10v10h-10zM220 180h10v10h-10zM230 190h10v10h-10zM250 200h10v10h-10zM260 210h10v10h-10zM270 220h10v10h-10zM310 230h10v10h-10zM330 180h10v10h-10zM340 190h10v10h-10zM300 250h10v10h-10zM290 260h10v10h-10zM280 270h10v10h-10zM270 280h10v40h-10z" fill-opacity="0.25" fill="#ffffff"/> <path d="M190 170h10v10h-10zM200 180h10v10h-10zM210 190h10v10h-10zM220 200h10v10h-10zM230 210h10v10h-10zM260 240h10v20h-10zM250 260h10v10h-10zM240 270h10v40h-10v10h10v10h-10v10h-20v-10h-10v-10h10v-10h10v-10h10zM250 230h10v10h-10zM300 210h10v20h-10zM310 200h10v10h-10zM320 190h10v10h-10zM240 220h10v10h-10zM290 230h10v10h-10z" fill-opacity="0.25" fill="#000000"/>';//branch shadows
        parts[19] = '<path d="M230 340h50v10h-50zM280 330h10v10h-10zM290 320h10v10h-10zM280 310h10v10h-10zM220 340h10v10h-10zM210 330h10v10h-10zM200 320h10v10h-10zM210 310h10v10h-10z" fill="';
        parts[20] = soilColors[bonsai.leafColor];
        parts[21] = '"/> <path d="M230 340h10v10h-10zM250 340h30v10h-30zM280 330h10v10h-10zM290 320h10v10h-10zM280 310h10v10h-10z" fill-opacity="0.2" fill="#000000"/>';//soil shadows
        parts[22] = potAccessories[bonsai.potAccessories];
        parts[23] = accessories[bonsai.accessories];
        parts[24] = '</svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7]));
        output = string(abi.encodePacked(output, parts[8], parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15]));
        output = string(abi.encodePacked(output, parts[16], parts[17], parts[18], parts[19], parts[20], parts[21], parts[22], parts[23]));
        output = string(abi.encodePacked(output, parts[24]));

        return output;
    }

    function tokenURI(uint tokenId) override public view returns (string memory) {
        cryptoBonsai memory bonsai = randomBonsai(tokenId);
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bonsai #', Strings.toString(tokenId), '", "description": "Bonsais are 100% on chain and randomly generated to bring tranqulity to your blockchain. Very zen.", ', '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(getBonsaiSVG(bonsai))), '"', getTraits(bonsai), '}'))));
        json = string(abi.encodePacked('data:application/json;base64,', json));
        return json;
    }

    function addToWhitelist(uint256 amount, address[] calldata entries) onlyOwner external {
        for(uint i=0; i<entries.length; i++){
            address entry = entries[i];
            require(entry != address(0), "NULL_ADDRESS");
            require(!_whiteList[entry], "DUPLICATE_ENTRY");
            _whiteList[entry] = true;
            _whiteListLimit[entry] = amount;
        }
    }

    function addToFounderList(uint256 amount, address[] calldata founder) onlyOwner external {
        for(uint i=0; i<founder.length; i++) {
            address founders = founder[i];
            require(founders != address(0), "NULL_ADDRESS");
            require(!_founderList[founders], "DUPLICATE_ENTRY");
            _founderList[founders] = true;
            _founderLimit[founders] = amount;
        }
    }

    function removeFromWhitelist(address[] calldata entries) external onlyOwner {
        for(uint256 i = 0; i < entries.length; i++) {
            address entry = entries[i];
            require(entry != address(0), "NULL_ADDRESS");
            _whiteList[entry] = false;
        }
    }

    // function whitelistInfoFor(address _addr) public view returns (bool isWhiteListed, uint256 numHasMinted, uint256 allottedMints) {
    //     // isWhiteListed = _whiteList[_addr];
    //     // numHasMinted = _whiteListPurchases[_addr];
    //     // allottedMints = _whiteListLimit[_addr];
    // }

    // function mintedInfoFor(address _addr) public view returns (uint256 numHasMinted) {
    //     numHasMinted = _mintPerAddress[_addr];
    // }

    function mint(address destination, uint256 amountOfTokens) private {
        //require(!allSalesPaused, "Sale is paused right now");
        require(totalSupply() < maxSupply, "All tokens have been minted");
        require(totalSupply() + amountOfTokens <= maxSupply, "Minting would exceed max supply");
        require(amountOfTokens > 0, "Must mint at least one token");
        require(price * amountOfTokens == msg.value, "ETH amount is incorrect");
        require(_mintPerAddress[msg.sender] + amountOfTokens <= maxPerAddress,  "You can't exceed this wallet's minting limit");
        require(amountOfTokens <= maxMint, "Cannot purchase this many tokens in a transaction");
        
        if (privateSaleIsActive) {
            require(_whiteList[msg.sender], "Buyer not whitelisted for this private sale");
            require(_whiteListPurchases[msg.sender] + amountOfTokens <= _whiteListLimit[msg.sender], "Cannot mint more than 5 Bonsais during presale");
            _whiteListPurchases[msg.sender] = _whiteListPurchases[msg.sender] + amountOfTokens;
        }

        // if(founderMints) {
        //     require(_founderList[msg.sender], "Buyer is not a founder");
        //     require(_founderPurchases[msg.sender] + amountOfTokens <= _founderLimit[msg.sender]);
        //     _founderPurchases[msg.sender] = _founderPurchases[msg.sender] + amountOfTokens;
        //     price = 0 ether;
        //     maxMint = _founderLimit[msg.sender];
        //     maxPerAddress = _founderLimit[msg.sender];
        // } else {
        //     price = 0.01 ether;
        //     maxMint = 100;
        //     maxPerAddress = 100;
        // }

        for (uint256 i = 0; i < amountOfTokens; i++) {
            uint256 tokenId = numTokensMinted + 1;
            _safeMint(destination, tokenId);
            numTokensMinted += 1;
            _mintPerAddress[msg.sender] += 1;
        }
    }

    function founderMint(uint256 amountOfTokens) public {
        //require(founderMints);
        require(_founderList[msg.sender], "Buyer is not a founder");
        require(totalSupply() < maxSupply, "All tokens have been minted");
        require(totalSupply() + amountOfTokens <= maxSupply, "Minting would exceed max supply");
        require(amountOfTokens > 0, "Must mint at least one token");
        require(_mintPerAddress[msg.sender] + amountOfTokens <= _founderLimit[msg.sender],  "You can't exceed this wallet's minting limit");
        require(amountOfTokens <= _founderLimit[msg.sender], "Cannot purchase this many tokens in a transaction");

        // if(founderMints) {
        //     require(_founderList[msg.sender], "Buyer is not a founder");
        //     require(_founderPurchases[msg.sender] + amountOfTokens <= _founderLimit[msg.sender]);
        //     _founderPurchases[msg.sender] = _founderPurchases[msg.sender] + amountOfTokens;
        // } 

        for (uint256 i = 0; i < amountOfTokens; i++) {
            uint256 tokenId = numTokensMinted + 1;
            _safeMint(msg.sender, tokenId);
            numTokensMinted += 1;
            _mintPerAddress[msg.sender] += 1;
        }
    }
    
    function mintBonsai(uint256 amountOfTokens) public payable virtual {
        mint(_msgSender(),amountOfTokens);
    }

    // function toggleAllSalesPaused() public onlyOwner {
    //     allSalesPaused = !allSalesPaused;
    // }

    function enablePublicSale() public onlyOwner {
        privateSaleIsActive = false;
    }

    function withdrawAll() public payable onlyOwner {
        require(payable(_msgSender()).send(address(this).balance));
    }
    
}