const daysTag = document.querySelector(".days"),
currentDate = document.querySelector(".current-date"),
prevNextIcon = document.querySelectorAll(".icons span");

let date = new Date(),
currYear = date.getFullYear(),
currMonth = date.getMonth();

const months = ["January", "February", "March", "April", "May", "June", "July",
              "August", "September", "October", "November", "December"];

let events = {}; 

const renderCalendar = () => {
    let firstDayofMonth = new Date(currYear, currMonth, 1).getDay(),
    lastDateofMonth = new Date(currYear, currMonth + 1, 0).getDate(),
    lastDayofMonth = new Date(currYear, currMonth, lastDateofMonth).getDay(),
    lastDateofLastMonth = new Date(currYear, currMonth, 0).getDate();
    let liTag = "";

    for (let i = firstDayofMonth; i > 0; i--) {
        liTag += `<li class="inactive">${lastDateofLastMonth - i + 1}</li>`;
    }

    for (let i = 1; i <= lastDateofMonth; i++) {
        let isToday = i === date.getDate() && currMonth === new Date().getMonth() 
                     && currYear === new Date().getFullYear() ? "active" : "";
        let eventText = events[`${currYear}-${currMonth + 1}-${i}`] ? `<span>${events[`${currYear}-${currMonth + 1}-${i}`]}</span>` : "";
        liTag += `<li class="${isToday}" data-date="${currYear}-${currMonth + 1}-${i}">${i}${eventText}</li>`;
    }

    for (let i = lastDayofMonth; i < 6; i++) {
        liTag += `<li class="inactive">${i - lastDayofMonth + 1}</li>`
    }
    currentDate.innerText = `${months[currMonth]} ${currYear}`;
    daysTag.innerHTML = liTag;

    const allDays = daysTag.querySelectorAll("li");
    allDays.forEach(day => {
        day.addEventListener("click", () => {
            allDays.forEach(d => d.classList.remove("selected"));
            day.classList.add("selected");
            let eventText = prompt("Enter event:");
            if (eventText) {
                events[day.dataset.date] = eventText;
            } else {
                delete events[day.dataset.date];
            }
            renderCalendar();
        });
    });
}
renderCalendar();

prevNextIcon.forEach(icon => {
    icon.addEventListener("click", () => {
        if (icon.id === "prev") {
            currMonth -= 1;
        } else if (icon.id === "next") {
            currMonth += 1;
        } else if (icon.id === "prev-year") {
            currYear -= 1;
        } else if (icon.id === "next-year") {
            currYear += 1;
        }

        if(currMonth < 0 || currMonth > 11) {
            date = new Date(currYear, currMonth, new Date().getDate());
            currYear = date.getFullYear();
            currMonth = date.getMonth();
        } else {
            date = new Date();
        }
        renderCalendar();
    });
});