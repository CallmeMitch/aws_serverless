
resource "aws_api_gateway_rest_api" "valAPI" {

  name = var.API_name

  endpoint_configuration {
    types = [var.API_types]
  }
}

resource "aws_api_gateway_deployment" "Deployment_API" {
  rest_api_id = aws_api_gateway_rest_api.valAPI.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.valAPI.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.GET_METHOD,
    aws_api_gateway_method.POST_METHOD,
    aws_api_gateway_integration.GET_integration,
    aws_api_gateway_integration.POST_integration
  ]
}

resource "aws_api_gateway_integration" "GET_integration" {
  rest_api_id             = aws_api_gateway_rest_api.valAPI.id
  resource_id             = aws_api_gateway_resource.valRessource.id
  http_method             = aws_api_gateway_method.GET_METHOD.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = var.uri
}

resource "aws_api_gateway_integration" "POST_integration" {
  rest_api_id             = aws_api_gateway_rest_api.valAPI.id
  resource_id             = aws_api_gateway_resource.valRessource.id
  http_method             = aws_api_gateway_method.POST_METHOD.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.uri
}

resource "aws_api_gateway_stage" "valstage" {
  deployment_id = aws_api_gateway_deployment.Deployment_API.id
  rest_api_id   = aws_api_gateway_rest_api.valAPI.id
  stage_name    = var.stage_name
}



## Ressource afin d'utiliser les méthodes GET et POST
resource "aws_api_gateway_resource" "valRessource" {
  rest_api_id = aws_api_gateway_rest_api.valAPI.id
  parent_id   = aws_api_gateway_rest_api.valAPI.root_resource_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "GET_METHOD" {
  rest_api_id   = aws_api_gateway_rest_api.valAPI.id
  resource_id   = aws_api_gateway_resource.valRessource.id
  http_method   = var.GET_METHOD
  authorization = "NONE"
  depends_on = [ var.uri ]
}

resource "aws_api_gateway_method" "POST_METHOD" {
  rest_api_id   = aws_api_gateway_rest_api.valAPI.id
  resource_id   = aws_api_gateway_resource.valRessource.id
  http_method   = var.POST_METHOD
  authorization = "NONE"
  depends_on = [ var.uri ]
}