console.log(`IP Address: ${ipAddress}`);
console.log(`Port: ${portep}`);

Swal.fire({
    title: "Fetching History . . . ",
    didOpen: () => {
        Swal.showLoading();
    },
});

fetch(`http://${ipAddress}:${portep}/alluserevents`)
    .then(response => {
        if (!response.ok) {
            Swal.fire({
                text: "Error fetching data",
                icon: "error",
                buttonsStyling: false,
                showConfirmButton: false,
                timer: 2000,
            });
            throw new Error("Network response was not ok");
        }
        return response.json();
    })
    .then(data => {
        Swal.close();

        console.log(data.length);
        renderTable(data.users);
    })
    .catch(error => {
        console.error("Error fetching data:", error);
        Swal.fire({
            text: "Error fetching data",
            icon: "error",
            buttonsStyling: false,
            showConfirmButton: false,
            timer: 2000,
        });
    });

function renderTable(users) {
    const eventsTable = document.getElementById("eventsTable");
    const tableBody = eventsTable.querySelector("tbody");
    tableBody.innerHTML = ""; // Clear existing table rows

    if (!Array.isArray(users) || users.length === 0) {
        const noDataMessageRow = document.createElement("tr");
        const noDataMessageCell = document.createElement("td");
        noDataMessageCell.textContent = "No history found";
        noDataMessageCell.colSpan = 10;
        noDataMessageCell.style.textAlign = "center";
        noDataMessageRow.appendChild(noDataMessageCell);
        tableBody.appendChild(noDataMessageRow);
    } else {
        users.forEach(user => {
            const newRow = document.createElement("tr");
            const userData = [
                user.id_user,
                user.user_name,
                user.license,
                user.minQuality,
                user.deviceId,
                user.date,
                user.time,
                user.Methode,
            ];

            userData.forEach(dataValue => {
                const cell = createCell(dataValue, true);
                newRow.appendChild(cell);
            });

            // Create button cell or no image message
            const buttonCell = document.createElement("td");
            if (user.Methode === "Camera Action") {
                const button = document.createElement("button");
                button.textContent = "Show Image";
                button.classList.add("btn", "btn-primary");
                button.onclick = () => showImage(user._id); 
                buttonCell.appendChild(button);
            } else if (user.Methode === "Phone Action") {
                const noImageSpan = document.createElement("span");
                noImageSpan.textContent = "  No image found";
                noImageSpan.classList.add("text-muted");
                buttonCell.appendChild(noImageSpan);
            }
            newRow.appendChild(buttonCell);

            tableBody.appendChild(newRow);
        });
    }
}

function createCell(content, addTextClasses) {
    const cell = document.createElement("td");
    if (addTextClasses) {
        const span = document.createElement("span");
        span.classList.add("text-dark", "fw-bold", "text-hover-primary", "d-block", "mb-1", "fs-6");
        span.textContent = content;
        cell.appendChild(span);
    } else {
        cell.textContent = content;
    }
    return cell;
}

async function showImage(id) {
    try {
        Swal.fire({
            title: "Loading . . . ",
            didOpen: () => {
                Swal.showLoading();
            },
        });
        const response = await fetch(`http://${ipAddress}:${portep}/usersoid/${id}`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        Swal.close();

        const data = await response.json();
        const imageData = data.imageData;
        const imageUrl = `data:image/jpeg;base64,${imageData}` ;
        Swal.close();

        const popupHtml = `
            <div class="popup-overlay" onclick="closePopup(event)">
                <div class="popup-content">
                    <p class="popup-title">Licence Plate Image</p>
                    <span class="popup-close" onclick="document.querySelector('.popup-overlay').remove()">&times;</span>
                    <img src="${imageUrl}" alt="Licence Plate Image" class="popup-image" />
                </div>
            </div>
        `;

        const style = document.createElement('style');
        style.innerHTML = `
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
            .popup-content {
                background: white;
                padding: 20px;
                border-radius: 15px;
                text-align: center;
                position: relative;
                max-width: 80%;
                margin: 0 20px;
            }
            .popup-title {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 10px;
                margin-top: 10px;
            }
            .popup-close {
                position: absolute;
                top: 10px;
                right: 10px;
                font-size: 24px;
                cursor: pointer;
                margin: 10px;
            }
            .popup-image {
                max-width: 100%;
                height: auto;
                border-radius: 15px;
                margin: 25px 0;
            }
        `;
        document.head.appendChild(style);

        // Append the pop-up HTML to the body
        document.body.insertAdjacentHTML('beforeend', popupHtml);

    } catch (error) {
        console.error("Error fetching image data:", error);
        Swal.fire({
            text: "Error fetching image data",
            icon: "error",
            buttonsStyling: false,
            showConfirmButton: false,
            timer: 2000,
        });
    }
}

// Function to close the popup when clicking outside of it
function closePopup(event) {
    if (event.target.classList.contains('popup-overlay')) {
        document.querySelector('.popup-overlay').remove();
    }
}

async function updateTableBySearchInput() {
    const searchInput = document.querySelector('[data-kt-customer-table-filter="search"]');
    const searchText = searchInput.value.trim().toLowerCase();

    try {
        let endpoint = `http://${ipAddress}:${portep}/usersLogs`;

        if (searchText) {
            endpoint += `/${searchText}`;
        }
        Swal.fire({
            title: "Fetching History . . . ",
            didOpen: () => {
                Swal.showLoading();
            },
        });

        const response = await fetch(endpoint);

        if (response.status === 404) {
            Swal.close();

            const eventsTable = document.getElementById("eventsTable");
            const tableBody = eventsTable.querySelector("tbody");
            tableBody.innerHTML = ""; 
            
            const noDataMessageRow = document.createElement("tr");
            const noDataMessageCell = document.createElement("td");
            noDataMessageCell.textContent = "No history found";
            noDataMessageCell.colSpan = 8; 
            noDataMessageCell.style.textAlign = "center"; 
            noDataMessageRow.appendChild(noDataMessageCell);
            tableBody.appendChild(noDataMessageRow);

            return; 
        }

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        Swal.close();


        const events = await response.json();
        renderTable(events.users);
    } catch (error) {
        console.error("Error fetching events:", error);
        Swal.fire({
            text: "Error fetching events",
            icon: "error",
            buttonsStyling: false,
            showConfirmButton: false,
            timer: 2000,
        });
    }
}

document.addEventListener("DOMContentLoaded", function() {
    const searchInput = document.querySelector('[data-kt-customer-table-filter="search"]');
    searchInput.addEventListener("input", updateTableBySearchInput);
    updateTableBySearchInput();
});


document.getElementById('logout').addEventListener('click', function() {
    Swal.fire({
        title: 'Are you sure you want to Logout?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes',
        cancelButtonText: 'No',
        buttonsStyling: false,
        customClass: {
            confirmButton: 'btn btn-danger',
            cancelButton: 'btn btn-secondary'
        }
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = 'login.html';
        }
    });
});



/* document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('about-link').addEventListener('click', function(event) {
        event.preventDefault();
        showAbout();
    });
});

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
                            ${generateImageHtml('Yassine Manai', '/static/yassine_img.JPG', 'Dev Team / ', '+216 93 014 027', 'yassinemanai955@gmail.com')}
                            ${generateImageHtml('Sofiene Zayati', '/static/blank.png', 'Dev Team / ', '+216 55 321 315', 'sofienezayati87@gmail.com')}
                        <div class="section-title">
                            <h2>Supervisors</h2>
                        </div>
                            ${generateImageHtml('Sami Melki', '/static/blank.png', 'ISET Supervisor', '', '')}
                            ${generateImageHtml('Zied Bradai', '/static/blank.png', 'Scheidt & Bachmann Maghreb Supervisor', '', '')}
                    </div>
            </div>
        </div>
    `;
    const style = document.createElement('style');
    style.innerHTML = `
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
            width: 250px;
            height: 200px;
            border-radius: 15px;
        }
    `;
    document.head.appendChild(style);

    // Append the pop-up HTML to the body
    document.body.insertAdjacentHTML('beforeend', popupHtml);
}

function generateImageHtml(title, imageUrl, description,contact, email) {
    return `
        <div class="image-item">
            <img src="${imageUrl}" heighttalt="${title}" class="popup-image" />
            <p class="image-title">${title}</p>
            <span class="image-description">${description}</span>
            <span class="image-description">    ${contact}</span>
            <p class="image-description">${email}</p>

        </div>
    `;
} */