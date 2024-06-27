
## PART ::: LAMBDA
filename        = "lambda_app.zip"
runtime         = "python3.11"
function_name   = "lambda_handler"
handler         = "lambda_app.lambda_handler"

## PART ::: API REST
API_name        = "valAPI"
API_types       = "REGIONAL"
stage_name      = "valstage"
path_part       = "hello"
GET_METHOD      = "GET"
POST_METHOD     = "POST"