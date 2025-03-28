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
    println!("Running service at: 127.0.0.1:8080");

    HttpServer::new(|| {
        // All origins are allowed in localhost
        let cors = Cors::permissive();
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
