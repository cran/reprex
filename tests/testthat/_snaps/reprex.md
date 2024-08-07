# reprex() works with code that deals with srcrefs

    [1] "``` r"                                                    
    [2] "utils::getParseData(parse(text = 'a'))"                   
    [3] "#>   line1 col1 line2 col2 id parent  token terminal text"
    [4] "#> 1     1    1     1    1  1      3 SYMBOL     TRUE    a"
    [5] "#> 3     1    1     1    1  3      0   expr    FALSE"     
    [6] "```"                                                      

# reprex() errors for an R crash, by default

    Code
      code <- "rlang::node_car(0)\n"
      reprex(input = code)
    Condition
      Error in `reprex_render()`:
      ! This reprex appears to crash R. Call `reprex()` again with `std_out_err = TRUE` to get more info.

# reprex() copes with an R crash, when `std_out_err = TRUE`

    Code
      out
    Output
      [1] "This reprex appears to crash R."
      [2] "See standard output and standard error for more details."
      [3] ""
      [4] "#### Standard output and error"
      [5] ""
      [6] "``` sh"
      [7] ""
      [8] " *** caught segfault ***"
      [9] "address ADDRESS, cause 'CAUSE'"
      [10] ""
      [11] "Traceback:"

