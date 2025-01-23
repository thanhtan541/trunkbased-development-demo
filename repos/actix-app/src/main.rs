use actix_cors::Cors;
use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder, Result};
use serde::Serialize;

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world!")
}

#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}

#[derive(Serialize)]
struct MyProfile {
    name: String,
    role: String,
}

#[get("/profile")]
async fn profile() -> Result<impl Responder> {
    let obj = MyProfile {
        name: "tan541".into(),
        role: "dev".into(),
    };

    Ok(web::Json(obj))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        let cors = Cors::default()
            //Todo: Put to confguration and don't use localhost. it cause prelight problem in FE.
            .allowed_origin("http://127.0.0.1:8000")
            .allowed_methods(vec!["GET", "POST", "OPTIONS"])
            // .allowed_header(http::header::CONTENT_TYPE)
            .max_age(3600);
        App::new()
            .wrap(cors)
            .service(hello)
            .service(echo)
            .service(profile)
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
