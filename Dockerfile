FROM ubuntu:14.04

MAINTAINER Matthew Upson
LABEL date="2016-11-29"
LABEL version="0.1.1-rap-demo-md"
LABEL description="Reproducible Analytical Pipeline environment"

# Update server and install git (probably already installed)

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y git \ 
    && apt-get install -y software-properties-common

# Install the current version of R (current is 3.3.2)

RUN echo "deb http://cloud.r-project.org/bin/linux/ubuntu trusty/" | tee -a /etc/apt/sources.list > /dev/null \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 \
    && add-apt-repository -y ppa:marutter/rdev \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install r-recommended=3.3.2-1trusty0 -y --force-yes \ 
    && apt-get install r-base=3.3.2-1trusty0 -y --force-yes \ 
    && apt-get install r-base-html=3.3.2-1trusty0 -y --force-yes \ 
    && apt-get install r-doc-html=3.3.2-1trusty0 -y --force-yes 

# Install dependencies for R packages

RUN apt-get install -y libcurl4-openssl-dev libxml2-dev libxslt-dev

# Copy setup.R file into tea_book

WORKDIR /RAP

# Clone to RAP-demo-md repo into RAP

RUN git clone https://github.com/UKGov-Data-Science/RAP-demo-md.git RAP-demo-md

# Run setup in R to install required packages

COPY ./setup.R /RAP/

RUN chmod +x setup.R \ 
    && Rscript setup.R

ENTRYPOINT ["Rscript"]

# List Arguments for compilation (might be better as a script)

CMD ["-e","rmarkdown::render(input='index.Rmd',output_format='html_document',output_file='index.html')"]

