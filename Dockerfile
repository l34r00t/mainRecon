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
    zip \
    unzip

COPY mainRecon/mainRecon.sh mainRecon/ 
RUN chmod +x mainRecon/mainRecon.sh

# Install go
WORKDIR /tmp
RUN \
    wget -q https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz -O go.tar.gz && \
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
    wget --quiet https://github.com/Findomain/Findomain/releases/download/5.1.1/findomain-linux -O /tools/findomain/findomain && \
    chmod +x /tools/findomain/findomain && \
    ln -s /tools/findomain/findomain /usr/bin/findomain && \
    # Install assetfinder
    go install github.com/tomnomnom/assetfinder@latest && \
    # Install amass
    wget --quiet https://github.com/OWASP/Amass/releases/download/v3.5.5/amass_v3.5.5_linux_amd64.zip -O /tools/amass/amass.zip && \
    unzip /tools/amass/amass.zip -d /tools/amass/ && \
    rm /tools/amass/amass.zip && \
    ln -s /tools/amass/amass_v3.5.5_linux_amd64/amass /usr/bin/amass && \
    # Install httprobe
    go install github.com/tomnomnom/httprobe@latest && \
    # Install waybackurls
    go install github.com/tomnomnom/waybackurls@latest && \
    # Install aquatone
    go get github.com/shelld3v/aquatone && \
    ln -s /root/go/bin/aquatone /usr/bin/aquatone && \
    # Install Nez Zile
    git clone https://github.com/bonino97/new-zile.git && \
    pip3 install termcolor && \
    # Install Linkfinder
    git clone https://github.com/GerbenJavado/LinkFinder.git && \
    # Install waybackurls
    go install github.com/tomnomnom/waybackurls@latest && \
    # Install subfinder
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    # Install ParamSpider
    git clone https://github.com/devanshbatham/ParamSpider && \
    pip3 install -r ParamSpider/requirements.txt && \
    # Install Dirsearch
    git clone https://github.com/maurosoria/dirsearch.git && \
    # Install ffuf
    go install github.com/ffuf/ffuf@latest && \
    # Install unfurl
    go install github.com/tomnomnom/unfurl@latest && \
    # Install subjs
    go install github.com/lc/subjs@latest

# Findomain configuration
ENV findomain_fb_token="ENTER_TOKEN_HERE"
ENV findomain_virustotal_token="ENTER_TOKEN_HERE"
ENV findomain_securitytrails_token="ENTER_TOKEN_HERE"
ENV findomain_spyse_token="ENTER_TOKEN_HERE"

WORKDIR /tools/LinkFinder/
RUN \
    python3 setup.py install && \
    pip3 install -r requirements.txt


# Change workdir
WORKDIR /mainData
ENTRYPOINT ["/mainRecon/mainRecon.sh"]
