# Stage 1: Build Go tools
FROM golang:1.24-bookworm AS go-builder
RUN go install github.com/tomnomnom/assetfinder@latest && \
    go install github.com/owasp-amass/amass/v3/cmd/amass@latest && \
    go install github.com/tomnomnom/httprobe@latest && \
    go install github.com/tomnomnom/waybackurls@latest && \
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/ffuf/ffuf@latest && \
    go install github.com/tomnomnom/unfurl@latest && \
    go install github.com/lc/subjs@latest && \
    GO111MODULE=on go install github.com/jaeles-project/gospider@latest

# Stage 2: Final image
FROM python:3.11-slim-bookworm

LABEL maintainer="l34r00t" \
    email="leandro@leandropintos.com"

# API tokens: pass at runtime with docker run -e findomain_fb_token=xxx
# Do not declare them here to avoid SecretsUsedInArgOrEnv warnings.

# Install required system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    grep \
    chromium \
    git \
    curl \
    wget \
    unzip \
    zip \
    bash \
    ca-certificates \
    libmagic1 \
    && rm -rf /var/lib/apt/lists/*

# Copy Go tool binaries from builder stage
COPY --from=go-builder /go/bin/ /usr/local/bin/

# Create tools directory
RUN mkdir -p /tools/findomain /tools/aquatone /tools/amass

# Install Findomain
RUN wget --quiet "https://github.com/findomain/findomain/releases/latest/download/findomain-linux.zip" -O /tools/findomain/findomain.zip && \
    unzip /tools/findomain/findomain.zip -d /tools/findomain && \
    chmod +x /tools/findomain/findomain && \
    ln -s /tools/findomain/findomain /usr/bin/findomain && \
    rm /tools/findomain/findomain.zip

# Install Aquatone
RUN wget --quiet "https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip" -O /tools/aquatone/aquatone.zip && \
    unzip /tools/aquatone/aquatone.zip -d /tools/aquatone && \
    chmod +x /tools/aquatone/aquatone && \
    ln -s /tools/aquatone/aquatone /usr/bin/aquatone && \
    rm /tools/aquatone/aquatone.zip && \
    rm -f /tools/aquatone/README.md /tools/aquatone/LICENSE.txt

# Install Python tools
RUN git clone --depth 1 https://github.com/bonino97/new-zile.git /tools/new-zile && \
    git clone --depth 1 https://github.com/maurosoria/dirsearch.git /tools/dirsearch && \
    pip install --no-cache-dir -r /tools/dirsearch/requirements.txt && \
    git clone --depth 1 https://github.com/GerbenJavado/LinkFinder.git /tools/LinkFinder && \
    pip install --no-cache-dir -e /tools/LinkFinder && \
    git clone --depth 1 https://github.com/devanshbatham/ParamSpider /tools/ParamSpider && \
    pip install --no-cache-dir -e /tools/ParamSpider && \
    pip install --no-cache-dir termcolor

# Ensure Python scripts have a proper shebang so they run with python3
RUN for f in /tools/new-zile/zile.py /tools/LinkFinder/linkfinder.py /tools/dirsearch/dirsearch.py; do \
        head -1 "$f" | grep -q '^#!' || sed -i '1i#!/usr/bin/env python3' "$f"; \
    done

# Create symlinks for tools expected in PATH by mainRecon.sh
RUN ln -sf /tools/new-zile/zile.py /usr/local/bin/zile.py && chmod +x /tools/new-zile/zile.py && \
    ln -sf /tools/LinkFinder/linkfinder.py /usr/local/bin/linkfinder.py && chmod +x /tools/LinkFinder/linkfinder.py && \
    ln -sf /tools/dirsearch/dirsearch.py /usr/local/bin/dirsearch.py && chmod +x /tools/dirsearch/dirsearch.py && \
    ln -sf /usr/local/bin/paramspider /usr/local/bin/paramspider.py 2>/dev/null || true

# Setup mainRecon
WORKDIR /mainRecon/
COPY mainRecon/mainRecon.sh .
RUN chmod +x ./mainRecon.sh

# Set entrypoint
WORKDIR /mainData
ENTRYPOINT ["/mainRecon/mainRecon.sh"]
