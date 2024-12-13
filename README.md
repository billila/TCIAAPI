
# TCIAAPI R package

## Installation

Currently, the package only resides on GitHub.

``` r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("billila/TCIAAPI")
```

## Package load

``` r
library(TCIAAPI)
```

## Introduction

The `TCIAAPI` package provides an interface to the Cancer Imaging
Archive (TCIA) API. The TCIA API allows users to programmatically access
the TCIA data. The package provides functions to obtain an access token,
download SVS images, and retrieve metadata from the TCIA API.

## Access Token

The TCIA API requires an access token to access the data. The
`tcia_access_token` function retrieves the access token from the TCIA
API. By default, it is configured to obtain a public token. Note that
the token expires after a certain period of time and must be refreshed.

``` r
tcia_access_token() |> httr2::obfuscate()
#> obfuscated("uIJOTZbFg4WVnxIcxM5kXSraFzVPme70YgbSD6kTFdOK9ntXcmaFqebueiCinqTa5TxD2_IXFw1O5-6I9o1xD6DMh2cYYyAGCFqt9StvFjLt5sJ3nVEXqZylJoqz6nUFuh_ahDHB9VnJwBcDqI_s-eFn04ci4djWJ2u9BpWkwtRdTYDO8CZyqTvqOkeE9_PB6Wb5i9lj3J5xzhdgCFPwHgfhdiBXO3TPWcrsFy-J-MPGYMW4mN8BTeGZa97LT1iqr9Jug6yFNlbuVuaz3eACT2gGASCHaNzv0WqjKGfuTdBPyl8ysK45uewbkuNsLx7OVKJM4Cg1AZgDZEzcQf0Ijec9anKSYcN5OI_VDykDW07yAR-GPC-rh21jbD2Mq5ex8i3IeFEpVl8RSGSQU8etRRPuYt7rMS0mzuF2DAZ0-uhFYtEFrL9VZa4pnaeQb0BnMVPCvX1QtxaW8-mPDmVZ9ABCnMa-fGt2KNRO_ul0i-vEUajnHX72sk8FZaKwMVEnpQdqR3S3T_nVQmAVTrkGhE5Cn0utx1wv4UmS4L0QHqdEuN9xObPz2GsQE0jj4yKTzi1oqoSmtc2OY8OoZ2x5v2NfW69wKh9IKAHdCfj4JbiXLYyKg4cP4LqOFY5IYM96M_soMVTWJgi2VnpuPrv64j1TDakiIlV7uLyhhRCdiNKKwjImTd690CyuVGZn56T4nXmCplZdmpKInewXPxgf4bZJeLWOOTo-GFCqEH3Z7yX4iUfuy7BqvjpnhqHO255ZP-k8mo0kYrdIVYsRdxl8zsGzHZ2AXfCuzcxHTaZbiGj18uMCaFgEMLmiKB9En6v2G4tKgDNFPWdUp-Y3NCzYsPSMyg1cM2EJsC9zY8IffNsy8JLA9mGRYD_BNqus7dAAYU-ofpJ9VO1f-mp04_IF6WN-rKey6mdOJ2bhJfSjNKy7WApplqRhGNEkgCiOk5HI39Ka8JjXspXNsuzmesovf-eyVFeEaBoGJSFoY561Q9koK3ju4GNwEc491VGgP37bBnF7ecnN_Kh_69D-UYW0QCVNh6-ZyJVAyfhAuAii_rdgbQ7de0LXU2zPFtu9NQmN3NgIcvZZ8JNVjIvJv5AdV5crc6VWxjL-BmH0fXBeEkfHV9Wz4C-wOugpsem8wQV82xMNu1Gp3XzIODg12geAHQi9s01Vv8EyKHWbBNnM77TL6ic2u_zL")
```

Note that we use `httr2::obfuscate` to hide the token from the output.

## Information on SVS Images

The `tcia_svs_info` function retrieves metadata information on SVS
images from the TCIA API. The function requires a `camic_id` which is
obtained from the ‘TCIA Histopathology Custom Dataset Builder.json’
file. The json file can be obtained by navigating to the TCIA website
<https://www.cancerimagingarchive.net/> under ‘Access The Data’, ‘Search
Histopathology Portal’ and clicking on the ‘TCIA Histopathology Custom
Dataset Builder’ link.

``` r
svsinfo <- tcia_svs_info("311781") 
svsinfo |> head(3L)
#> $nid
#> $nid[[1]]
#> $nid[[1]]$value
#> [1] 311781
#> 
#> 
#> 
#> $uuid
#> $uuid[[1]]
#> $uuid[[1]]$value
#> [1] "b66f827a-1090-4a52-8696-950947f4a2bc"
#> 
#> 
#> 
#> $vid
#> $vid[[1]]
#> $vid[[1]]$value
#> [1] 633285
```

### Download URL

The `tcia_svs_info` function returns a list containing the metadata of
the SVS including the download URL. The download URL can be used to
download the SVS images.

``` r
svsinfo[["field_wsiimage"]][[1L]][["url"]]
#> [1] "http://pathdb.cancerimagingarchive.net/system/files/wsi/ross/Biobank/curated/CMB-AML/MSB-02960-04-02.svs"
```

Note that currently the package does not provide a function to download
the ~150 MB json file programmatically.

## Download SVS Images

The `tcia_svs_download` function downloads SVS images from the TCIA API.
Like `tcia_svs_info`, the function requires a `camic_id` which can be
obtained from the ‘TCIA Histopathology Custom Dataset Builder.json’
file.

``` r
tcia_svs_download("311781")
#' [1] "/tmp/RtmpjrBN7Z/MSB-02960-04-02.svs"
```

The function downloads the SVS images to the temporary directory by
default. The `destdir` argument can be used to specify a different
directory.

# SessionInfo

``` r
sessionInfo()
#> R Under development (unstable) (2024-11-01 r87285)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 22.04.5 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.10.0 
#> LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.10.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> time zone: America/New_York
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] TCIAAPI_0.1.2 httr2_1.0.7  
#> 
#> loaded via a namespace (and not attached):
#>  [1] digest_0.6.37       R6_2.5.1            codetools_0.2-20   
#>  [4] fastmap_1.2.0       xfun_0.49           magrittr_2.0.3     
#>  [7] rappdirs_0.3.3      glue_1.8.0          knitr_1.49         
#> [10] htmltools_0.5.8.1   rmarkdown_2.29      lifecycle_1.0.4    
#> [13] cli_3.6.3           askpass_1.2.1       openssl_2.2.2      
#> [16] compiler_4.5.0      rstudioapi_0.17.1   tools_4.5.0        
#> [19] curl_6.0.1          evaluate_1.0.1      yaml_2.3.10        
#> [22] BiocManager_1.30.25 crayon_1.5.3        jsonlite_1.8.9     
#> [25] rlang_1.1.4
```
