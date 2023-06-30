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
font_flag_var=""
font_flag_lig=""
font_prop=""
font_file_name=""
font_link=""

JetBrainsMono=(
    "Bold"
    "BoldItalic"
    "ExtraBold"
    "ExtraBoldItalic"
    "ExtraLight"
    "ExtraLightItalic"
    "Italic"
    "Light"
    "LightItalic"
    "Medium"
    "MediumItalic"
    "Regular"
    "SemiBold"
    "SemiBoldItalic"
    "Thin"
    "ThinItalic"
)

get_font_name() {
    name=$1
    if [[ ${name:-4} = "Mono" ]]; then
        font_name=(${name:0:-4} "Mono")
    else
        font_name=(${name})
    fi

    debug_sep
    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font_name: "${font_name}
    fi
}

get_font_flag_var() {
    var=$1
    font_flag_var=${var}

    debug_sep
    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font_flag_var: "${font_flag_var}
    fi
}

get_font_flag_lig() {
    if [ $# -eq 0 ]; then
        lig=true
    else
        lig=$1
    fi

    font_flag_lig=("Ligatures" "")
    if [[ ${lig} = false ]]; then
        font_flag_lig=("NoLigatures" "NL")
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
    # set -- ${weight_and_style}
    font_prop=$1

    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font_prop: "${font_prop}
    fi
}

get_font_file_name() {
    font_file_name=""
    file_name_elements=(
        ${font_name[0]}
        ${font_name[2]}
        ${font_flag_lig[1]}
        "Nerd Font"
        ${font_flag_var}
        ${font_prop}
    )
    for element in ${file_name_elements[@]}; do
        font_file_name+=${element}" "
    done
    font_file_name=${font_file_name:0:-1}".ttf" # Remove last space

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
        ${font_prop}"/"
        ${font_name[0]}
        ${font_name[1]}
        ${font_name[2]}
        ${font_name[3]}
        ${font_flag_lig[1]}
        "NerdFont"
        ${font_flag_var}
        "-"
        ${font_prop}
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
    var=$3

    if [[ ${debug_active} = true ]]; then
        echo "Function: "${FUNCNAME[0]}
        echo "font: "${1}
        echo "lig: "${2}
        echo "mono: "${3}
    fi

    get_font_name ${font}
    get_font_flag_lig ${lig}
    if [ $# -eq 3 ]; then
        get_font_flag_var ${var}
    fi

    change_dir

    # Use arg[1] as part of an array name
    # Source: https://unix.stackexchange.com/a/60585
    font=$1[@]
    download "${!font}"
}

# arg[1] string Font name
# arg[2] boolean Use ligatures
# arg[3] string Use Mono or Propo variant
init $1 $2 $3
