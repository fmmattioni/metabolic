## Test environments

* local: darwin15.6.0-3.6.1
* travis: 3.1, 3.2, 3.3, oldrel, release, devel
* r-hub: windows-x86_64-devel, ubuntu-gcc-release, fedora-clang-devel
* win-builder: windows-x86_64-devel

## R CMD check results

0 errors | 0 warnings | 0 notes

## Comments from previous submission:

Thanks, please correct in your Description text:

> (2020)<doi:10.1249/MSS.0000000000002506>.
> -->
> (2020) <doi:10.1249/MSS.0000000000002506>.


> You are wrapping your examples in if(interactive()) {...} since the
> examples cannot run in this way. I.e.
> 
> build_gofer(page = "1", save = TRUE, path =
> "~/Documents/metabolic_gofer_page_1")
> 
> Please ensure that your functions do not modify (save or delete) the
> user's home filespace in your examples/vignettes/tests. That is not
> allow by CRAN policies. Please only write/save files if the user has
> specified a directory. In your examples/vignettes/tests you can write to
> tempdir(). I.e.
> 
> build_gofer(page = "1", save = TRUE, path = tempdir())
> 
> 
> Please fix and resubmit.> 

All of the above was corrected accordingly.

## Comments from previous submission:

> Thanks,
> 
> Please write references in the description of the DESCRIPTION file in
> the form
> authors (year) <doi:...>
> authors (year) <arXiv:...>
> authors (year, ISBN:...)
> or if those are not available: authors (year) <[https:...]https:...>
> with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for
> auto-linking.
> (If you want to add a title as well please put it in quotes: "Title")
> 
> Please make sure that you do not change the user's options, par or
> working directory. If you really have to do so within functions, please
> ensure with an *immediate* call of on.exit() that the settings are reset
> when the function is exited. e.g.:
> ...
> oldpar <- par(no.readonly = TRUE)       # code line i
> on.exit(par(oldpar))                    # code line i + 1
> ...
> par(mfrow=c(2,2))                       # somewhere after
> ...
> e.g.: plot.R
> If you're not familiar with the function, please check ?on.exit. This
> function makes it possible to restore options before exiting a function
> even if the function breaks. Therefore it needs to be called immediately
> after the option change within a function.
> 
> 
> Please fix and resubmit.> 

All of the above was corrected accordingly.

## Comments from previous submission:

> Thanks, we see:
> 
>    Found the following (possibly) invalid URLs:
>      URL: https://journals.lww.com/10.1249/MSS.0000000000002506 (moved
> to
> https://journals.lww.com/acsm-msse/Abstract/9000/Effectiveness_of_HIIE_versus_MICT_in_Improving.96194.aspx)
>        From: inst/CITATION
>        Status: 200
>        Message: OK
>      URL: https://t.co/3jIDvEYOAJ (moved to
> https://twitter.com/will_s_t/status/1090937361251385344/photo/1)
>        From: inst/doc/gofer.html
>        Status: 200
>        Message: OK
>      URL: https://t.co/OlHIQ5mtwd (moved to
> https://www.bmj.com/content/364/bmj.l42)
>        From: inst/doc/gofer.html
>        Status: 200
>        Message: OK
> 
> Please change http --> https, add trailing slashes, or follow moved
> content as appropriate.
> 
> 
>    The Title field should be in title case. Current version is:
>    'Dataset and Functions for Reproducing Meta-analysis'
>    In title case that is:
>    'Dataset and Functions for Reproducing Meta-Analysis'
> 
> 
> I think this should actually be corrected grammatically in two places
> and hence be
> 
>    'Datasets and Functions for Reproducing Meta-Analyses'
> 
> 
> 
> 
>    Size of tarball: 11153400 bytes
> 
> Not more than 5 MB for a CRAN package.
> 
> 
> Please fix and resubmit.

All of the above was corrected accordingly.
