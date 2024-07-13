// CSS as a string to be injected into the document
const styles = `
.popup-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
            .section-title {
            grid-column: span 2;
            text-align: center;
            margin: 20px 0;
        }
            .main-title {
            text-align: left;
            margin-left: 20px;
        }
        .popup-content {
            background: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            position: relative;
            max-width: 100%;
            margin: 0 20px;
            width: 70%
            overflow-y: auto;
        }
        .popup-close {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 24px;
            cursor: pointer;
        }
        .image-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-gap: 20px;
            margin: 20px;
        }
        .image-item {
            text-align: center;
        }
        .image-title {
                    font-size: 18px;
            font-weight: bold;
            margin: 10px 0;
        }
        .image-description {
            font-size: 14px;
        }
        .popup-image {
            object-fit: contain;
            width: 250px;
            height: 200px;
            border-radius: 15px;
        }
`;

// Function to add the CSS to the document
function addStyles() {
    const style = document.createElement('style');
    style.innerHTML = styles;
    document.head.appendChild(style);
}

// Function to generate the HTML for an image
function generateImageHtml(title, imageUrl, description, contact, email) {
    return `
        <div class="image-item">
            <img src="${imageUrl}" alt="${title}" class="popup-image" />
            <p class="image-title">${title}</p>
            <span class="image-description">${description}</span>
            <span class="image-description">${contact}</span>
            <p class="image-description">${email}</p>
        </div>
    `;
}

// Function to show the "About Us" popup
function showAbout() {
    const popupHtml = `
        <div class="popup-overlay" onclick="closePopup(event)">
            <div class="popup-content">
                <br/>
                <h1 class="main-title">About Us</h1>
                <span class="popup-close" onclick="document.querySelector('.popup-overlay').remove()">&times;</span>
                    <div class="image-container">
                        <div class="section-title">
                            <h2>Students</h2>
                        </div>
                            ${generateImageHtml('Yassine Manai', '/static/yass2.png', 'Dev Team / ', '+216 93 014 027', 'yassinemanai955@gmail.com')}
                            ${generateImageHtml('Sofiene Zayati', '/static/sofiene.jpeg', 'Dev Team / ', '+216 55 321 315', 'sofienezayati87@gmail.com')}
                        <div class="section-title">
                            <h2>Supervisors</h2>
                        </div>
                            ${generateImageHtml('Sami Melki', '/static/blank.png', 'ISET Supervisor', '', '')}
                            ${generateImageHtml('Zied Bradai', '/static/zied.jpeg', 'Scheidt & Bachmann Maghreb Supervisor', '', '')}
                    </div>
            </div>
        </div>
    `;
    document.body.insertAdjacentHTML('beforeend', popupHtml);
}

// Event listener to show the popup when the link is clicked
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('about-link').addEventListener('click', function(event) {
        event.preventDefault();
        showAbout();
    });
    addStyles();
});
