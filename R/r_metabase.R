#' Authenticate to Metabase
#'
#' Initialize an authenticated session with Metabase.
#'
#' @param base_url The base URL of your Metabase server
#' @param username The username to log in as
#'
#' @return Metabaser session
#'
#' @examples
#' mb_session <- metabase_init(base_url, username)
#'
#' @export
metabase_init <- function (base_url, username, password = NULL) {
  if (is.null(password) && exists('.rs.askForPassword')) {
    prompt <- paste("Enter Metabase Password for ", username)
    password <- .rs.askForPassword(prompt)
  }

  creds<-list(
    username = username,
    password = password
  )
  credsAsJSON <- jsonlite::toJSON(creds, auto_unbox=TRUE)

  req <- httr::POST(mb_url(base_url, '/api/session'),
                    httr::add_headers(
                      "Content-Type" = "application/json"
                    ),
                    body = credsAsJSON
  )

  if (req$status_code >= 200 && req$status_code < 300) {
    jsonAuthResponse <- httr::content(req, "text")
    mb_session_token <- toString(jsonlite::fromJSON(jsonAuthResponse))

    # make sure session is legit
    mb_session <- list(
      base_url = base_url,
      token = mb_session_token
    )
    return(mb_session)
  } else {
    return(NULL)
  }
}

#' Fetch the data for a Metabase question.
#'
#' Runs the question and returns the data from the question in a dataframe.
#'
#' @param metabase_session The metabase object
#' @param id The question id
#' @param params A list of parameters to pass to the question (defaults to no params)
#'
#' @return datab frame
#'
#' @examples
#' metabase_fetch_question(sess, 242)
#' metabase_fetch_question(sess, 242, list(customer_id = 4))
#'
#' @export
metabase_fetch_question <- function(metabase_session, id, params = list()) {
  mb_verify_session(metabase_session)

  data<-list(
    "ignore_cache" = FALSE,
    "parameters"   = params
  )
  dataAsJSON <- jsonlite::toJSON(data, auto_unbox=TRUE)

  query_url_part = paste0('/api/card/', id, '/query/json', "")
  req <- httr::POST(mb_url(metabase_session$base_url, query_url_part),
                    httr::add_headers(
                      "Content-Type" = "application/json",
                      "X-Metabase-Session" = metabase_session$token
                    )
  );
  mb_req_error_processor(req)

  questionJSON <- httr::content(req,"text")
  questionData <- jsonlite::fromJSON(questionJSON)
}

## INTERNAL HELPER FUNCTIONS
mb_url <- function(base_url, path) {
  paste0(base_url, path, "")
}

mb_req_error_processor <- function(req) {
  if (req$status_code != 200) {
    stop(paste("Request failed:", req$url, " returned: ", req$status_code))
  }
}

mb_verify_session <- function(metabase_session) {
  if (is.null(metabase_session)) {
    stop("Invalid metabase session.")
  }
}
