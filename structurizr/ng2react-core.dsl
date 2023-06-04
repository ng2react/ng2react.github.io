typescript = component "Typescript" "AST Parsing" "JavaScript" "External"
ng2react_core = component "@ng2react/core" "Core business logic" "JavaScript" {
    this -> typescript "Uses"
    this -> openAi "Makes API calls to" "JSON/HTTPS"
}