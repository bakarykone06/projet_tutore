function connexion(){

    let email = document.getElementById("email").value;
    let password = document.getElementById("password").value;

    if(email === "" || password === ""){
        alert("Veuillez remplir tous les champs");
        return;
    }

    window.location.href="videos.html";
}