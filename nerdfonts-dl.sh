#!/bin/bash -

debug_active=false
debug_sep() {
    if [[ ${debug_active} != true ]]; then
        return 0
    fi

    double_sep=""
    single_sep=""
    for ((j = 0; j < 40; j++)); do
        double_sep+="=="
        single_sep+="-"
    done

    if [[ $1 = true ]]; then
        echo ${double_sep}
    else
        echo ${single_sep}
    fi
}

font_name=""
font_flag_mono=""
font_flag_lig=""
font_prop1=""
font_prop2=""
font_file_name=""
font_link=""

JetBrainsMono=(
    "Bold"
    "Bold Italic"
    "ExtraBold"
    "ExtraBold Italic"
    "ExtraLight"
    "ExtraLight Italic"
    "Italic"
    "Light"
    "Light Italic"
    "Medium"
    "Medium Italic"
    "Regular"
    "SemiBold"
    "SemiBold Italic"
    "Thin"
    "Thin Italic"
)

get_font_name() {
    name=$1
    if [[ ${name:(-4)} = "Mono" ]]; then
        font_name=(${name:0:-4} "%20" "Mono" "%20")
    else
        font_name=(${name} "%20")
    fi

    debug_sep
    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font_name: "${font_name}
    fi
}

get_font_flag_mono() {
    mono=$1
    font_flag_mono=""
    if [[ ${mono} = true ]]; then
        font_flag_mono="Mono%20"
    fi

    debug_sep
    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font_flag_mono: "${font_flag_mono}
    fi
}

get_font_flag_lig() {
    lig=$1
    font_flag_lig=("Ligatures" "")
    if [[ ${lig} = false ]]; then
        font_flag_lig=("NoLigatures" "%20" "NL")
    fi

    debug_sep
    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font_flag_lig: "${font_flag_lig}
    fi
}

get_font_prop_and_style() {
    weight_and_style=("$@")
    # Source: https://unix.stackexchange.com/a/719138
    # Split words in string
    set -- ${weight_and_style}
    font_prop1=$1
    font_prop2=("" $2)
    if [[ -n $2 ]]; then
        font_prop2[0]="%20"
    fi

    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font_prop1: "${font_prop1}
        echo "font_prop2[0]: "${font_prop2[0]}
        echo "font_prop2[1]: "${font_prop2[1]}
    fi
}

get_font_file_name() {
    font_file_name=""
    file_name_elements=(
        ${font_name[0]}
        ${font_name[2]}
        ${font_flag_lig[2]}
        "Nerd Font Complete"
        ${font_prop1}
        ${font_prop2[1]}
    )
    for element in ${file_name_elements[@]}; do
        font_file_name+=${element}" "
    done
    font_file_name='"'${font_file_name:0:-1}'.ttf"' # Remove last space

    debug_sep
    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font_file_name: "${font_file_name}
    fi
}

get_font_link() {
    font_link=""
    link_elements=(
        "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/"
        ${font_name[0]}
        ${font_name[2]}"/"
        ${font_flag_lig[0]}"/"
        ${font_prop1}
        ${font_prop2[1]}"/"
        "complete/"
        ${font_name[0]}
        ${font_name[1]}
        ${font_name[2]}
        ${font_name[3]}
        ${font_flag_lig[2]}
        ${font_flag_lig[1]}
        "Nerd%20Font%20Complete%20"
        ${font_prop1}
        ${font_prop2[0]}
        ${font_prop2[1]}
        ".ttf"
    )
    for element in ${link_elements[@]}; do
        font_link+=${element}
    done

    debug_sep
    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font_link: "${font_link}
    fi
}

change_dir() {
    target_dir="${HOME}/Downloads/fonts"
    mkdir -p ${target_dir}
    cd ${target_dir}

    debug_sep
    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "target_dir: "${target_dir}
        ls
    fi
}

download() {
    font=("$@")
    for ((i = 0; i < ${#font[@]}; i++)); do
        debug_sep true

        get_font_prop_and_style "${font[$i]}"
        get_font_file_name
        get_font_link

        debug_sep
        if [[ ${debug_active} = true ]]; then
            echo "Function: "${FUNCNAME[0]}
            echo curl -fLo "${font_file_name}" ${font_link}
        fi
        curl -fLo "${font_file_name}" ${font_link}
    done
}

init() {
    font=$1
    lig=$2
    mono=$3

    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font: "${1}
        echo "lig: "${2}
        echo "mono: "${3}
    fi

    get_font_name ${font}
    get_font_flag_lig ${lig}
    get_font_flag_mono ${mono}

    change_dir

    # Use arg[1] as part of an array name
    # Source: https://unix.stackexchange.com/a/60585
    font=$1[@]
    download "${!font}"
}

# arg[1] string Font name
# arg[2] boolean Use ligatures
# arg[3] boolean Use monospaced variant
init $1 $2 $3
