OSS_PWD=""

ossupload(){
  ossutil cp "$2" "$OSS_PWD/$2"
}

ossdownload(){
  ossutil cp "$OSS_PWD/$1" "$2"
}

osspwd(){
  echo $OSS_PWD
}


osscd(){
  OSS_PWD=$1
}


ossls(){
  local oss_pwd=${1:-$OSS_PWD}
  if [ "$oss_pwd" == ""  ]; then
      ossutil ls
  else
      ossutil ls -d "$oss_pwd"
  fi
}

complete_fun_generate(){
  local a=$(cat <<E_COMPLETE
$1(){
    local cmd="\${1##*/}";
    local word=\${COMP_LINE//osscd/};
    if [[ \$word == "" ]]; then
        COMPREPLY=(\$(IFS=$'\n'; __CMD));
    else
        COMPREPLY=(\$(IFS=$'\n'; __CMD \$word));
    fi
}
E_COMPLETE
)
#   eval $a;
    eval ${a//__CMD/$2}
}


complete_fun_generate _osscd osslsf

complete -F _osscd osscd

osslsf(){
  local oss_pwd=${1:-$OSS_PWD}
  if [ "$oss_pwd" == ""  ]; then
      ossutil ls | awk 'NF>5{ print $NF }'
  else
      ossutil ls "$oss_pwd" -d | grep --color=NEVER "^oss"
  fi
}


