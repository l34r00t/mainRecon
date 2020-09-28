FROM ubuntu:18.04

LABEL maintainer="l34r00t" \
    email="leandro@leandropintos.com"

# Install packages
RUN \
    apt-get update && \
    apt-get install -y \
    python-setuptools \
    python3-setuptools \
    python3-pip \
    chromium-browser \
    git \
    curl \
    wget \
    python \
    python3 \
    unzip

COPY mainRecon/mainRecon.sh mainRecon/ 
RUN chmod +x mainRecon/mainRecon.sh

# Install go
WORKDIR /tmp
RUN \
    wget -q https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz -O go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz
ENV GOPATH "/root/go"
ENV PATH "$PATH:/usr/local/go/bin:$GOPATH/bin"

# TOOLS
RUN mkdir tools \
    mkdir -p /tools/findomain \
    mkidr -p /tools/amass \
    mkdir -p /tools/aquatone
     
WORKDIR /tools/
RUN \
    # Install findomain
    wget --quiet https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux -O /tools/findomain/findomain && \
    chmod +x /tools/findomain/findomain && \
    ln -s /tools/findomain/findomain /usr/bin/findomain && \
    # Install assetfinder
    go get -u github.com/tomnomnom/assetfinder && \
    # Install amass
    #wget --quiet https://github.com/OWASP/Amass/releases/download/v3.5.5/amass_v3.5.5_linux_amd64.zip -O /tools/amass/amass.zip && \
    #unzip /tools/amass/amass.zip -d /tools/amass/ && \
    #rm /tools/amass/amass.zip && \
    #ln -s /tools/amass/amass_v3.5.5_linux_amd64/amass /usr/bin/amass && \
    GO111MODULE=on go get -v github.com/OWASP/Amass/v3/... && \
    # Install httprobe
    go get -u github.com/tomnomnom/httprobe && \
    # Install waybackurls
    go get github.com/tomnomnom/waybackurls && \
    # Install aquatone
    wget --quiet https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O /tools/aquatone/aquatone.zip && \
    unzip /tools/aquatone/aquatone.zip -d /tools/aquatone/  && \
    rm /tools/aquatone/aquatone.zip && \
    ln -s /tools/aquatone/aquatone /usr/bin/aquatone && \
    # Install Nez Zile
    git clone https://github.com/bonino97/new-zile.git && \
    pip3 install termcolor && \
    # Install Linkfinder
    git clone https://github.com/GerbenJavado/LinkFinder.git && \
    # Install waybackurls
    go get github.com/tomnomnom/waybackurls && \
    # Install subfinder
    go get github.com/projectdiscovery/subfinder/v2/cmd/subfinder && \
    # Install ParamSpider
    git clone https://github.com/devanshbatham/ParamSpider && \
    pip3 install -r ParamSpider/requirements.txt && \
    # Install Dirsearch
    git clone https://github.com/maurosoria/dirsearch.git && \
    # Install ffuf
    go get github.com/ffuf/ffuf && \
    # Install unfurl
    go get -u github.com/tomnomnom/unfurl && \
    # Install subjs
    go get -u github.com/lc/subjs && \
    # Install chaos
    GO111MODULE=on go get -u github.com/projectdiscovery/chaos-client/cmd/chaos && \
    # Install shuffledns
    GO111MODULE=on go get -u -v github.com/projectdiscovery/shuffledns/cmd/shuffledns && \
    # Install seclist
    git clone https://github.com/danielmiessler/SecLists.git && \
    # Install nuclei
    GO111MODULE=on go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
    # Update nuclei-templates
    # nuclei -update-templates

# Findomain configuration
ENV findomain_fb_token="ENTER_TOKEN_HERE"
ENV findomain_virustotal_token="ENTER_TOKEN_HERE"
ENV findomain_securitytrails_token="ENTER_TOKEN_HERE"
ENV findomain_spyse_token="ENTER_TOKEN_HERE"
ENV chaos_key="ENTER_KEY_HERE"
ENV token="ENTER_KEY_HERE"
ENV chat_ID="ENTER_KEY_HERE"

WORKDIR /tools/LinkFinder/
RUN \
    python3 setup.py install && \
    pip3 install -r requirements.txt


# Change workdir
WORKDIR /mainData
ENTRYPOINT ["/mainRecon/mainRecon.sh"]
