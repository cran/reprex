% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reprex-undo.R
\name{un-reprex}
\alias{un-reprex}
\alias{reprex_invert}
\alias{reprex_clean}
\alias{reprex_rescue}
\title{Un-render a reprex}
\usage{
reprex_invert(
  input = NULL,
  wd = NULL,
  venue = c("gh", "r"),
  comment = opt("#>"),
  outfile = deprecated()
)

reprex_clean(
  input = NULL,
  wd = NULL,
  comment = opt("#>"),
  outfile = deprecated()
)

reprex_rescue(
  input = NULL,
  wd = NULL,
  prompt = getOption("prompt"),
  continue = getOption("continue"),
  outfile = deprecated()
)
}
\arguments{
\item{input}{Character. If has length one and lacks a terminating newline,
interpreted as the path to a file containing the reprex. Otherwise,
assumed to hold the reprex as a character vector. If not provided, the
clipboard is consulted for input. If the clipboard is unavailable and
we're in RStudio, the current selection is used.}

\item{wd}{An optional filepath that is consulted when \code{input} is not a
filepath. (By default, all work is done, quietly, in a subdirectory of the
session temp directory.)

The most common use of \code{wd} is to set \code{wd = "."}, which means "reprex right
HERE in the current working directory". Do this if you really must
demonstrate something with local files.}

\item{venue}{Character. Must be one of the following (case insensitive):
\itemize{
\item "gh" for \href{https://github.github.com/gfm/}{GitHub-Flavored Markdown}, the
default
\item "r" for a runnable R script, with commented output interleaved. Also useful
for \href{https://slack.com/intl/en-ca/slack-tips/share-code-snippets}{Slack code snippets};
select "R" from the "Type" drop-down menu to enjoy nice syntax
highlighting.
\item "rtf" for
\href{https://en.wikipedia.org/wiki/Rich_Text_Format}{Rich Text Format}
(not supported for un-reprexing)
\item "html" for an HTML fragment suitable for inclusion in a larger HTML
document (not supported for un-reprexing)
\item "slack" for pasting into a Slack message. Optimized for people who opt out
of Slack's WYSIWYG interface. Go to
\strong{Preferences > Advanced > Input options} and select "Format messages with
markup". (If there is demand for a second Slack venue optimized for use
with WYSIWYG, please open an issue to discuss.)
\item "so" for
\href{https://stackoverflow.com/editing-help#syntax-highlighting}{Stack Overflow Markdown}.
Note: this is just an alias for "gh", since Stack Overflow started to
support CommonMark-style fenced code blocks in January 2019.
\item "ds" for Discourse, e.g.,
\href{https://forum.posit.co/}{forum.posit.co}. Note: this is
currently just an alias for "gh".
}}

\item{comment}{regular expression that matches commented output lines}

\item{outfile}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}} in favor of \code{wd} or
providing a filepath to \code{input}. To reprex in current working directory,
use \code{wd = "."} now, instead of \code{outfile = NA}.}

\item{prompt}{character, the prompt at the start of R commands}

\item{continue}{character, the prompt for continuation lines}
}
\value{
Character vector holding just the clean R code, invisibly
}
\description{
Recover clean, runnable code from a reprex captured in the wild and write it
to user's clipboard. The code is also returned invisibly and optionally
written to file. Three different functions address various forms of
wild-caught reprex:
\itemize{
\item \code{reprex_invert()} attempts to reverse the effect of \code{\link[=reprex]{reprex()}}. When
\code{venue = "r"}, this just calls \code{reprex_clean()}.
\item \code{reprex_clean()} removes commented output. This assumes that R code is
top-level, possibly interleaved with commented output, e.g., a displayed
reprex copied from GitHub or the output of \code{reprex(..., venue = "R")}.
\item \code{reprex_rescue()} removes lines of output and strips prompts from lines
holding R commands. This assumes that R code lines start with a prompt and
that printed output is top-level, e.g., what you'd if you've copied from
the R Console.
}
}
\examples{
\dontrun{
# a roundtrip: R code --> rendered reprex, as gfm --> R code
original <- file.path(tempdir(), "original.R")
writeLines(glue::glue("
  #' Some text
  #+ chunk-label-and-options-cannot-be-recovered, message = TRUE
  (x <- 1:4)
  #' More text
  y <- 2:5
  x + y"), con = original)
reprex(input = original, html_preview = FALSE, advertise = FALSE)
reprexed <- sub("[.]R$", "_reprex.md", original)
writeLines(readLines(reprexed))
unreprexed <- reprex_invert(input = reprexed)
writeLines(unreprexed)

# clean up
file.remove(
  list.files(dirname(original), pattern = "original", full.names = TRUE)
)
}
\dontrun{
# a roundtrip: R code --> rendered reprex, as R code --> original R code
code_in <- c(
  "# a regular comment, which is retained",
  "(x <- 1:4)",
  "median(x)"
)
reprexed <- reprex(input = code_in, venue = "r", advertise = FALSE)
writeLines(reprexed)
code_out <- reprex_clean(input = reprexed)
writeLines(code_out)
identical(code_in, code_out)
}
\dontrun{
# rescue a reprex that was copied from a live R session
from_r_console <- c(
  "> # a regular comment, which is retained",
  "> (x <- 1:4)",
  "[1] 1 2 3 4",
  "> median(x)",
  "[1] 2.5"
)
rescued <- reprex_rescue(input = from_r_console)
writeLines(rescued)
}
}
