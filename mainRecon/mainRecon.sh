#!/bin/bash

# Colours
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
end="\e[0m"

# Banner
echo -e $yellow"
                  _                 
 ._ _   _. o ._  |_)  _   _  _  ._  
 | | | (_| | | | | \ (/_ (_ (_) | |

@leapintos | leandro@leandropintos.com
-----------|--------------------------
By_l34r00t | {v1.0}
@p0ch4t    | 
Sheryx00   | {v1.1}
"$end

# Usage
Usage() {
    echo -e "$green
Usage: ./mainRecon.sh [-p/--program] hackerone [-f/--file] targets.txt [-e/--exclude] exclude.txt [OPTIONAL] -s [OPTIONAL]
	"$end
    exit 1
}

# Bot Telegram
bot_token=$token
chat_ID=$chat_ID
url="https://api.telegram.org/bot$bot_token/sendMessage"

# Functions

check_root(){
	if [ "$(id -u)" != "0" ]; then
		echo -e $red"[X] Este programa solo puede ejecutarse siendo ROOT!"$end
		exit 1
	fi
}

check_dependencies(){
	echo -e $green"[+] "$end"Chequeando dependencias...\n"
	mkdir -p /opt/tools_mainRecon > /dev/null 2>&1
	export PATH="$PATH:/opt/tools_mainRecon"
	dependencies=(findomain assetfinder amass subfinder httprobe waybackurls aquatone zile.py linkfinder.py paramspider.py subjs dirsearch.py unfurl)
	for program in "${dependencies[@]}"; do
		which $program > /dev/null 2>&1
		if [ "$(echo $?)" -ne "0" ]; then
			echo -e $red"[X] $program "$end"no esta instalado."
			case $program in
				findomain) 
					echo -e "${yellow}[..]${end} Instalando $program"
					wget -q --show-progress https://github.com/Findomain/Findomain/releases/download/5.1.1/findomain-linux -O /opt/tools_mainRecon/findomain && chmod +x /opt/tools_mainRecon/findomain && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				assetfinder) 
					echo -e "${yellow}[..]${end} Instalando $program"
					apt install $program -y > /dev/null 2>&1 && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				amass) 
					echo -e "${yellow}[..]${end} Instalando $program"
					apt install $program -y > /dev/null 2>&1 && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				subfinder) 
					echo -e "${yellow}[..]${end} Instalando $program"
					apt install $program -y > /dev/null 2>&1 && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				httprobe) 
					echo -e "${yellow}[..]${end} Instalando $program"
					apt install $program -y > /dev/null 2>&1 && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				waybackurls)
					echo -e "${yellow}[..]${end} Instalando $program"
					wget -q --show-progress https://github.com/tomnomnom/waybackurls/releases/download/v0.1.0/waybackurls-linux-amd64-0.1.0.tgz -O /opt/tools_mainRecon/waybackurls.tgz && tar -xzf /opt/tools_mainRecon/waybackurls.tgz -C /opt/tools_mainRecon/ && rm /opt/tools_mainRecon/waybackurls.tgz && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				aquatone)
					echo -e "${yellow}[..]${end} Instalando $program"
					wget -q --show-progress https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O /opt/tools_mainRecon/aquatone.zip && unzip -q /opt/tools_mainRecon/aquatone.zip -d /opt/tools_mainRecon && rm /opt/tools_mainRecon/aquatone.zip /opt/tools_mainRecon/README.md /opt/tools_mainRecon/LICENSE.txt && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				zile.py)
					echo -e "${yellow}[..]${end} Instalando $program"
					wget https://raw.githubusercontent.com/bonino97/new-zile/master/zile.py -q --show-progress -O /opt/tools_mainRecon/zile.py && chmod +x /opt/tools_mainRecon/zile.py && sed -i '1s/^/#!\/usr\/bin\/python3\n/' /opt/tools_mainRecon/zile.py && pip3 install termcolor -q && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				linkfinder.py)
					echo -e "${yellow}[..]${end} Instalando $program"
					cd /opt/tools_mainRecon; git clone https://github.com/GerbenJavado/LinkFinder.git -q && pip3 install -r LinkFinder/requirements.txt -q && ln -s /opt/tools_mainRecon/LinkFinder/linkfinder.py /opt/tools_mainRecon/linkfinder.py && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				paramspider.py)
					echo -e "${yellow}[..]${end} Instalando $program"
					cd /opt/tools_mainRecon; git clone https://github.com/devanshbatham/ParamSpider -q && pip3 install -r ParamSpider/requirements.txt -q && ln -s /opt/tools_mainRecon/ParamSpider/paramspider.py /opt/tools_mainRecon/paramspider.py && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				subjs)
					echo -e "${yellow}[..]${end} Instalando $program"
					wget -q --show-progress https://github.com/lc/subjs/releases/download/v1.0.1/subjs_1.0.1_linux_amd64.tar.gz -O /opt/tools_mainRecon/subjs.tar.gz && tar -xzf /opt/tools_mainRecon/subjs.tar.gz -C /opt/tools_mainRecon/ && rm /opt/tools_mainRecon/subjs.tar.gz /opt/tools_mainRecon/LICENSE /opt/tools_mainRecon/README.md && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				dirsearch.py)
					echo -e "${yellow}[..]${end} Instalando $program"
					wget -q --show-progress https://github.com/maurosoria/dirsearch/archive/refs/tags/v0.4.0.zip -O /opt/tools_mainRecon/dirsearch.zip && unzip -q /opt/tools_mainRecon/dirsearch.zip -d /opt/tools_mainRecon/ && rm /opt/tools_mainRecon/dirsearch.zip && ln -s /opt/tools_mainRecon/dirsearch-0.4.0/dirsearch.py /opt/tools_mainRecon/dirsearch.py && echo -e "${green}[V] $program${end} instalado correctamente!"
					;;
				unfurl)
					echo -e "${yellow}[..]${end} Instalando $program"
					wget -q --show-progress https://github.com/tomnomnom/unfurl/releases/download/v0.4.0/unfurl-linux-amd64-0.4.0.tgz -O /opt/tools_mainRecon/unfurl-linux-amd64-0.4.0.tgz && tar -xzf /opt/tools_mainRecon/unfurl-linux-amd64-0.4.0.tgz -C /opt/tools_mainRecon/ && rm /opt/tools_mainRecon/unfurl-linux-amd64-0.4.0.tgz && echo -e "${green}[V] $program${end} instalado correctamente!"
			esac
		else
			echo -e $green"[V] $program"$end
		fi
	done
}

get_subdomains() {

    folder=$program-$(date '-I')
    mkdir $folder && cd $folder

    if [ ! -z $strict ];then
        echo -e $red"[+]"$end $bold"Strict Mode"$end
        cp /mainData/$file domains.txt
    else
        echo -e $red"[+]"$end $bold"Get Subdomains"$end
        echo -e $green"[+]"$end $bold"Running findomain"$end
        findomain -q -f /mainData/$file -r -u findomain_domains.txt
        echo -e $green"[+]"$end $bold"Running amass"$end
        amass enum -df /mainData/$file -active -o ammas_active_domains.txt
        cat /mainData/$file | assetfinder --subs-only >>assetfinder_domains.txt
        echo -e $green"[+]"$end $bold"Running subfinder"$end
        subfinder -dL /mainData/$file -o subfinder_domains.txt
        sort -u *_domains.txt -o subdomains.txt
        cat subdomains.txt | rev | cut -d . -f 1-3 | rev | sort -u | tee root_sub_domains.txt
        cat *.txt | sort -u > all_domains.txt
        if [ ! -z $exclude ];then
            echo -e $red"[+]"$end $bold"Excluding blacklisted domains"$end
            grep -v -f /mainData/$exclude all_domains.txt | tee domains.txt
        else
            mv all_domains.txt domains.txt
        fi
        find . -type f -name '*_domains.txt' -delete
    fi
}

get_alive() {
    echo -e $red"[+]"$end $bold"Get Alive"$end
    cat domains.txt | httprobe -c 50 -t 3000 >alive.txt
    cat alive.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" >alive.json
}

get_waybackurl() {
    echo -e $red"[+]"$end $bold"Get Waybackurl"$end

    mkdir waybackdata

    cat alive.txt | waybackurls > waybackdata/waybackurls.txt
    cat waybackdata/waybackurls.txt | sort -u | unfurl --unique keys >waybackdata/paramlist.txt
    cat waybackdata/waybackurls.txt | sort -u | grep -P "\w+\.js(\?|$)" | sort -u >waybackdata/jsurls.txt
    cat waybackdata/waybackurls.txt | sort -u | grep -P "\w+\.php(\?|$)" | sort -u >waybackdata/phpurls.txt
    cat waybackdata/waybackurls.txt | sort -u | grep -P "\w+\.aspx(\?|$)" | sort -u >waybackdata/aspxurls.txt
    cat waybackdata/waybackurls.txt | sort -u | grep -P "\w+\.jsp(\?|$)" | sort -u >waybackdata/jspurls.txt
    cat waybackdata/waybackurls.txt | sort -u | grep url= >waybackdata/open_url.txt
    cat waybackdata/waybackurls.txt | sort -u | grep redirect= >waybackdata/open_redirect.txt
    cat waybackdata/waybackurls.txt | sort -u | grep dest= >waybackdata/open_dest.txt
    cat waybackdata/waybackurls.txt | sort -u | grep path= >waybackdata/open_path.txt
    cat waybackdata/waybackurls.txt | sort -u | grep data= >waybackdata/open_data.txt
    cat waybackdata/waybackurls.txt | sort -u | grep domain= >waybackdata/open_domain.txt
    cat waybackdata/waybackurls.txt | sort -u | grep site= >waybackdata/open_site.txt
    cat waybackdata/waybackurls.txt | sort -u | grep dir= >waybackdata/open_dir.txt
    cat waybackdata/waybackurls.txt | sort -u | grep document= >waybackdata/document.txt
    cat waybackdata/waybackurls.txt | sort -u | grep root= >waybackdata/open_root.txt
    cat waybackdata/waybackurls.txt | sort -u | grep path= >waybackdata/open_path.txt
    cat waybackdata/waybackurls.txt | sort -u | grep folder= >waybackdata/open_folder.txt
    cat waybackdata/waybackurls.txt | sort -u | grep port= >waybackdata/open_port.txt
    cat waybackdata/waybackurls.txt | sort -u | grep result= >waybackdata/open_result.txt

    find waybackdata/ -size 0 -delete

    echo -e $green"[V] "$end"Waybackurl machine consultada correctamente."

}

get_aquatone() {
    echo -e $red"[+]"$end $bold"Get Aquatone"$end
    current_path=$(pwd)
    cat alive.txt | /usr/bin/aquatone -silent --ports xlarge -out $current_path/aquatone/ -http-timeout 60000 -threads 1 2>/dev/null
}

get_js() {
    echo -e $red"[+]"$end $bold"Get JS"$end

    mkdir jslinks

    cat alive.txt | subjs >>jslinks/all_jslinks.txt && echo -e $green"[V] "$end"Archivos JS obtenidos correctamente."
}

get_tokens() {
    echo -e $red"[+]"$end $bold"Get Tokens"$end

    mkdir tokens

    cat alive.txt waybackdata/jsurls.txt jslinks/all_jslinks.txt >tokens/all_js_urls.txt
    sort -u tokens/all_js_urls.txt -o tokens/all_js_urls.txt
    cat tokens/all_js_urls.txt | zile.py --request >>tokens/all_tokens.txt && echo -e $green"[V] "$end"Tokens obtenidos correctamente."
    sort -u tokens/all_tokens.txt -o tokens/all_tokens.txt
}

get_endpoints() {
    echo -e $red"[+]"$end $bold"Get Endpoints"$end

    mkdir endpoints

    for link in $(cat jslinks/all_jslinks.txt); do
        links_file=$(echo $link | sed -E 's/[\.|\/|:]+/_/g').txt
        python3 /opt/tools_mainRecon/LinkFinder/linkfinder.py -i $link -o cli >>endpoints/$links_file
    done

    echo -e $green"[V] "$end"Endpoints obtenidos correctamente."
}

get_params() {
    mkdir -p params/gospider

    echo -e $red"[+]"$end $bold"Normalizing and deduplicating domains"$end
    # Normalize and deduplicate domains
    unique_domains=$(cat alive.txt | sed -E 's|https?://||' | sort -u)

    for domain in $unique_domains; do
        echo -e $green"[+]"$end $bold"Running Paramspider: $domain"$end
        paramspider --domain "$domain" > /dev/null 2>&1
    done
    mv results params/paramspider

    echo -e $green"[+]"$end $bold"Running Gospider"$end
    gospider -S alive.txt -o params/gospider > /dev/null 2>&1
}

get_paths() {
    echo -e $red"[+]"$end $bold"Get Paths"$end
    current_path=$(pwd)
    mkdir dirsearch

    for host in $(cat alive.txt); do
        dirsearch_file=$(echo $host | sed -E 's/[\.|\/|:]+/_/g').txt
        python3 /tools/dirsearch/dirsearch.py -t 50 -O plain -o dirsearch/$dirsearch_file -u $host -w /tools/dirsearch/db/dicc.txt 2>/dev/null | grep Target && echo -e "\033[0m"
    done

    grep -R '200' dirsearch/ > dirsearch/status200.txt 2>/dev/null
    grep -R '301' dirsearch/ > dirsearch/status301.txt 2>/dev/null
    grep -R '302' dirsearch/ > dirsearch/status301.txt 2>/dev/null
    grep -R '400' dirsearch/ > dirsearch/status400.txt 2>/dev/null
    grep -R '401' dirsearch/ > dirsearch/status401.txt 2>/dev/null
    grep -R '403' dirsearch/ > dirsearch/status403.txt 2>/dev/null
    grep -R '404' dirsearch/ > dirsearch/status404.txt 2>/dev/null
    grep -R '405' dirsearch/ > dirsearch/status405.txt 2>/dev/null
    grep -R '500' dirsearch/ > dirsearch/status500.txt 2>/dev/null
    grep -R '503' dirsearch/ > dirsearch/status503.txt 2>/dev/null

    find dirsearch/ -size 0 -delete
}

get_zip() {
    echo -e $red"[+]"$end $bold"Zipping.."$end

    cd ..
    zip -rq $folder.zip $folder
}

get_message() {
    echo -e $red"[+]"$end $bold"Sending Message.."$end

    message="[ + ] mainRecon Alert:
    [ --> ] Recon Completed for $program #happyhacking"

    curl --silent --output /dev/null -F chat_id="$chat_ID" -F "text=$message" $url -X POST

    echo -e $green"[+] "$end"Escaneo completado con exito. Datos almacenados en: /opt/BugBountyPrograms/$folder"
}

programa=False
file=False
mode=False

list=(
    check_root
    check_dependencies
    get_subdomains
    get_alive
    get_waybackurl
    get_aquatone
    get_js
    get_tokens
    get_endpoints
    get_params
    get_paths
    get_zip
    get_message
)

while [ -n "$1" ]; do
    case "$1" in
    -p | --program)
        programa=$2
        shift
        ;;
    -f | --file)
        file=$(pwd)/$2
        shift
        ;;
    -e | --exclude)
    	exclude=$2
	    shift
    	;;
    -s | -strict-scope)
    	strict=true
	    shift
    	;;
    *)
        echo -e $red"[-]"$end "Unknown Option: $1"
        Usage
        ;;
    esac
    shift
done

[[ $programa == "False" ]] && [[ $file == "False" ]] && {
    echo -e $red"[-]"$end "Argument: -p/--program & -f/--file is Required"
    Usage
}

(
   get_subdomains
   get_alive
   get_waybackurl
   get_aquatone
   get_js
   get_tokens
   get_endpoints
   get_params
   get_paths
   get_zip
   get_message
)
