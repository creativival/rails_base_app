const inputFile = document.querySelector('#user_avatar');

inputFile.addEventListener('change', event => {
    // console.log(event.target)
    // console.log(event.target.value)
    // console.log(event.target.dataset)
    const size_in_megabytes = event.target.files[0].size/1024/1024,
        customFileLabel = document.querySelector('.custom-file-label');
    if (size_in_megabytes > 5) {
        const dataset = event.target.dataset;
        alert(dataset.message);
        event.target.value = '';
        customFileLabel.innerHTML = dataset.defaultLabel;
    } else {
        const label = event.target.value.replace(/\\/g, '/').replace(/.*\//, '');
        customFileLabel.innerHTML = label;
    }
});