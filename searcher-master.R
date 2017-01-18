library("shiny")
library("shinydashboard")
library("DT")

# This app requires your four data tables to be loaded from DataHelperFile.R
# Subsequent forks of this app can use less or more by amending code in app.r
#load("table1.dt.rda")
#load("table2.dt.rda")
#load("table3.rda")
#load("table4.rda")

ui <- dashboardPage(
  
  # Dashboard Header
  dashboardHeader(title = "SQL database browser"),
  
  # Dashboard Sidebar 
  dashboardSidebar(disable = TRUE),
  
  # Dashboard Body
  dashboardBody(
    
    # Sidebar Layout includes a single side bar and a main panel
    sidebarLayout(
      
      # Side Panel Main Page Layout Tab
      sidebarPanel(
        
        # Show this panel only if dataset is Table1
        conditionalPanel('input.dataset === "Table1"', helpText("Table1"),
                         checkboxGroupInput(
                           'show_vars1', 
                           'Columns in Table1 to show:', 
                           names(Table1.dt), 
                           selected = names(Table1.dt)
                         )
        ),
        
        # Show this panel only if dataset is Table2
        conditionalPanel('input.dataset === "Table2"', helpText("Table2"),
                         checkboxGroupInput(
                           'show_vars2', 
                           'Columns in Table2 to show:', 
                           names(Table2.dt), 
                           selected = names(Table2.dt))
        ),
        
        # Show this panel only if dataset is Table3
        conditionalPanel('input.dataset === "Table3"', helpText('Table3'),
                         checkboxGroupInput(
                           'show_vars3', 
                           'Columns in mir_main to show:', 
                           names(Table3.dt), 
                           selected = names(Table3.dt))
        ),
        
        # Show this panel only if the dataset is Table4
        conditionalPanel('input.dataset === "Table4"', helpText('Table4'),
                         checkboxGroupInput(
                           'show_vars4', 
                           'Columns in Table4 to show:', 
                           names(Table4.dt), 
                           selected = names(Table4.dt)
                         )
        ),
        
        # Sets the width of the sidebarPanel()
        width = 2),
      
      # Main panel of sidebar layout
      mainPanel(
        navbarPage(title = "Data browser",
                   id="dataset",
                   theme = "bootstrap.css",
                   position = "static-top",
                   tabPanel('cve_main', DT::dataTableOutput('cve_main_dt')),
                   tabPanel('cve_main_servers', DT::dataTableOutput('cve_main_servers_dt')),
                   tabPanel('mir_main', DT::dataTableOutput('mir_main_dt')),
                   tabPanel('mir_mbmrlogs', DT::dataTableOutput('mir_mbmrlogs_dt'))
        )
      )
    )
  )
)

server <- function(input, output) {
  
  #Global datatable Options
  options(DT.options = list(
    pageLength = 10, 
    language = list(search = 'Filter:'), 
    autoWidth = TRUE, 
    searchHighlight = TRUE,
    orderClasses = TRUE,
    
    # columnDefs = list(list(
    #   targets = c(4, 5, 6, 7, 8, 9, 10),
    #   render = JS(
    #     "function(data, type, row, meta) {",
    #     "return type === 'display' && data.length > 30 ?",
    #     "'<span title=\"' + data + '\">' + data.substr(0, 6) + '...</span>' : data;",
    #     "}"))), 
    
    initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
      "}"),
    
    lengthMenu = list(c(5, 10, 30, 50,-1), c("5", "10", "30", "50", "All"))
    
  ))
  
  output$cve_main_dt <- DT::renderDataTable({
    DT::datatable(filter = "bottom",
      cve.main.dt[, input$show_vars1, drop = FALSE], 
      options = list())}
  )
  
  output$cve_main_servers_dt <- DT::renderDataTable({
    DT::datatable(filter = "bottom",
      cve.main.servers.dt[, input$show_vars2, drop = FALSE], 
      options = list())}
  )
  
  output$mir_main_dt <- DT::renderDataTable({
    DT::datatable(filter = "bottom",
      mir.main.dt[, input$show_vars3, drop = FALSE], 
      options = list())}
  )
  
  output$mir_mbmrlogs_dt <- DT::renderDataTable({
    DT::datatable(filter = "bottom",
      mir.mbmrlogs.dt[, input$show_vars4, drop = FALSE], 
      options = list())}
  )
}

shinyApp(ui, server)
