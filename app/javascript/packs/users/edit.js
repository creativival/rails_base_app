$(document).on('change', ':file', function() {
    const size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
        const message = document.querySelector('#inputFile').dataset.message,
            default_label = document.querySelector('#inputFile').dataset.label;
        alert(message);
        document.querySelector('.custom-file-input').value = '';
        document.querySelector('.custom-file-label').innerHTML = default_label;
    } else {
        const label = $(this).val().replace(/\\/g, '/').replace(/.*\//, '');
        document.querySelector('.custom-file-label').innerHTML = label;
    }
});