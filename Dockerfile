FROM python:3.11-alpine

LABEL maintainer="l34r00t" \
    email="leandro@leandropintos.com"

# Now use the environment variables in the Dockerfile
ENV findomain_fb_token="ENTER_TOKEN_HERE"
ENV findomain_virustotal_token="ENTER_TOKEN_HERE"
ENV findomain_securitytrails_token="ENTER_TOKEN_HERE"
ENV findomain_spyse_token="ENTER_TOKEN_HERE"

# Install required packages and Go
RUN apk update && apk add --no-cache \
    grep \
    chromium \
    git \
    curl \
    wget \
    unzip \
    zip \
    go \
    bash \
    libmagic \
    && pip install --no-cache-dir termcolor

# Create tools directory
RUN mkdir -p /tools/findomain /tools/aquatone /tools/amass

# Install Findomain
RUN wget --quiet "https://github.com/findomain/findomain/releases/latest/download/findomain-linux.zip" -O /tools/findomain/findomain.zip && \
    unzip /tools/findomain/findomain.zip -d /tools/findomain && \
    chmod +x /tools/findomain/findomain && \
    ln -s /tools/findomain/findomain /usr/bin/findomain

# Install Aquatone
RUN wget --quiet "https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip" -O /tools/aquatone/aquatone.zip && \
    unzip /tools/aquatone/aquatone.zip -d /tools/aquatone && \
    chmod +x /tools/aquatone/aquatone && \
    ln -s /tools/aquatone/aquatone /usr/bin/aquatone

# Install Go tools
RUN go install github.com/tomnomnom/assetfinder@latest && \
    go install github.com/owasp-amass/amass/v3/cmd/amass@latest && \
    go install github.com/tomnomnom/httprobe@latest && \
    go install github.com/tomnomnom/waybackurls@latest && \
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/ffuf/ffuf@latest && \
    go install github.com/tomnomnom/unfurl@latest && \
    go install github.com/lc/subjs@latest && \
    GO111MODULE=on go install github.com/jaeles-project/gospider@latest

# Install Python tools
RUN git clone https://github.com/bonino97/new-zile.git /tools/new-zile && \
    git clone https://github.com/maurosoria/dirsearch.git --depth 1 /tools/dirsearch && \
    pip install -r /tools/dirsearch/requirements.txt && \
    git clone https://github.com/GerbenJavado/LinkFinder.git /tools/LinkFinder && \
    pip install -e /tools/LinkFinder && \
    git clone https://github.com/devanshbatham/ParamSpider /tools/ParamSpider && \
    pip install -e /tools/ParamSpider


# Setup mainRecon
WORKDIR /mainRecon/
COPY mainRecon/mainRecon.sh . 
RUN chmod +x ./mainRecon.sh

# Set entrypoint
WORKDIR /mainData
ENV PATH="$PATH:~/go/bin"
ENTRYPOINT ["/mainRecon/mainRecon.sh"]
