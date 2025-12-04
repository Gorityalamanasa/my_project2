function searchMovie() {
    const keyword = document.getElementById('searchInput').value;
    const genre = document.getElementById('genreSelect').value;
    const rating = document.getElementById('ratingSelect').value;

    fetch(`SearchServlet?query=${encodeURIComponent(keyword)}&genre=${encodeURIComponent(genre)}&rating=${encodeURIComponent(rating)}`)
        .then(res => res.text())
        .then(data => {
            document.getElementById('results').innerHTML = data;
        })
        .catch(error => {
            console.error('Error:', error);
        });
}
