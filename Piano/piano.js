const pianoKeys = document.querySelectorAll(".piano-keys .key"),
volumeSlider = document.querySelector(".volume-slider input"),
keysCheckbox = document.querySelector(".keys-checkbox input");

let allKeys = [],
audio = new Audio(`notes/a.wav`);

const playNote = (key) => {
    audio.src = `notes/${key}.wav`;
    audio.play(); 

    const clickedKey = document.querySelector(`[data-key="${key}"]`);
    clickedKey.classList.add("active"); 
    setTimeout(() => { 
        clickedKey.classList.remove("active");
    }, 150);
}

pianoKeys.forEach(key => {
    allKeys.push(key.dataset.key); 
    key.addEventListener("click", () => playNote(key.dataset.key));
});

const handleVolume = (e) => {
    audio.volume = e.target.value; 
}

const showHideKeys = () => {
    pianoKeys.forEach(key => {
        if (keysCheckbox.checked) {
            key.classList.remove("hide");
        } else {
            key.classList.add("hide");
        }
    });
}

const pressedKey = (e) => {
    if(allKeys.includes(e.key)) playNote(e.key);
}

keysCheckbox.addEventListener("click", showHideKeys);
volumeSlider.addEventListener("input", handleVolume);
document.addEventListener("keydown", pressedKey);