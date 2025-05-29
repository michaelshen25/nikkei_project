# app.R
library(shiny)
library(httr)
library(jsonlite)

ui <- fluidPage(
  titlePanel("Nikkei 225 LSTM Predictor"),
  sidebarLayout(
    sidebarPanel(
      h4("Enter the last 10 daily closes"),
      lapply(1:10, function(i) {
        numericInput(
          inputId = paste0("h", i),
          label   = paste("Day", i, "close:"),
          value   = NA,
          min     = 0
        )
      }),
      actionButton("go", "Predict")
    ),
    mainPanel(
      h3("Predicted Next Close:"),
      verbatimTextOutput("prediction")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    hist_vals <- sapply(1:10, function(i) input[[paste0("h", i)]])
    if (any(is.na(hist_vals))) {
      output$prediction <- renderText("Please fill in all 10 values.")
      return()
    }
    
    res <- POST(
    url    = "https://nikkei-api-609056186247.us-central1.run.app/predict",
    body   = toJSON(list(history = unname(hist_vals)), auto_unbox = TRUE),
    content_type_json()
    )

    if (status_code(res) != 200) {
      txt <- content(res, "text", encoding="UTF-8")
      output$prediction <- renderText(paste("Error:", txt))
    } else {
      out <- content(res, "parsed", simplifyVector = TRUE)
      output$prediction <- renderText(out$predicted_close)
    }
  })
}

shinyApp(ui, server)
