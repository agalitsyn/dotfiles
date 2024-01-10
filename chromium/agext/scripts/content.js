console.log("ag: start");

// page matcher
switch (window.location.hostname) {
    case "gitlab.ptsecurity.com":
        switch (getLastUrlSegment(window.location.href)) {
            case "pipelines":
                console.log("ag: gitlab pipelines patch");
                PatchGitlabPipelinesList();
                break;
            case "merge_requests":
                console.log("ag: gitlab merge requests patch");
                PatchGitlabMergeRequestsList();
                break;
            default:
                break;
        }
        break;
    default:
        break;
}

// Fix merge requests page, show concrete datetime instead of period
// This page is SSR
function PatchGitlabMergeRequestsList() {
    const nodes = document.querySelectorAll(".js-timeago");
    console.log(nodes);
    nodes.forEach((el) => {
        el.innerHTML = el.dateTime;
    });
}

// Fix pipelines
// And this page is not SSR!
function PatchGitlabPipelinesList() {
    // wait for loading
    setTimeout(() => {
        const nodes = document.querySelectorAll(".finished-at time");
        console.debug(nodes);
        nodes.forEach((el) => {
            el.innerHTML = el.dateTime;
        });
    }, 3000);
}

function getLastUrlSegment(url) {
    return new URL(url).pathname.split("/").filter(Boolean).pop();
}
