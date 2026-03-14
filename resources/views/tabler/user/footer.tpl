<div class="modal modal-blur fade" id="success-dialog" role="dialog">
    <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            <div class="modal-status bg-success"></div>
            <div class="modal-body text-center py-4">
                <i class="ti ti-circle-check icon mb-2 text-green icon-lg" style="font-size:3.5rem;"></i>
                <p id="success-message" class="text-secondary">{$t.footer.success}</p>
            </div>
            <div class="modal-footer">
                <div class="w-100">
                    <div class="row">
                        <div class="col">
                            <button type="button" id="success-confirm" class="btn w-100" data-bs-dismiss="modal">
                                {$t.footer.ok}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal modal-blur fade" id="fail-dialog" role="dialog">
    <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            <div class="modal-status bg-danger"></div>
            <div class="modal-body text-center py-4">
                <i class="ti ti-circle-x icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                <p id="fail-message" class="text-secondary">{$t.footer.failed}</p>
            </div>
            <div class="modal-footer">
                <div class="w-100">
                    <div class="row">
                        <div class="col">
                            <a href="" class="btn btn-danger w-100" data-bs-dismiss="modal">
                                {$t.footer.confirm}
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer footer-transparent d-print-none mt-auto">
    <div class="container-xl">
        <div class="row text-center align-items-center flex-row-reverse">
            <div class="col-lg-auto ms-lg-auto">
                <ul class="list-inline list-inline-dots mb-0">
                    <li class="list-inline-item">
                        {$t.footer.powered_by} <a href="/staff" class="link-secondary">SSPanel-UIM</a>
                    </li>
                </ul>
            </div>
            <div class="col-12 col-lg-auto mt-3 mt-lg-0">
                <ul class="list-inline list-inline-dots mb-0">
                    <li class="list-inline-item">
                        {$t.footer.theme_by} <a href="https://tabler.io/" class="link-secondary">Tabler</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</footer>
</div>
</div>
<script src="//{$config['jsdelivr_url']}/npm/@tabler/core@latest/dist/js/tabler.min.js"></script>
<script>
    function showToast(message, type) {
        var bgColor = type === 'danger' ? 'bg-danger' : 'bg-success';
        var toast = document.createElement('div');
        toast.className = 'position-fixed top-0 start-50 translate-middle-x mt-3 ' + bgColor + ' text-white px-4 py-2 rounded shadow';
        toast.style.zIndex = '9999';
        toast.style.transition = 'opacity 0.3s';
        toast.textContent = message;
        document.body.appendChild(toast);
        setTimeout(function() {
            toast.style.opacity = '0';
            setTimeout(function() { toast.remove(); }, 300);
        }, 2000);
    }

    window.addEventListener('load', function() {
        if (typeof tabler !== 'undefined' && tabler.bootstrap) {
            window.successDialog = new tabler.bootstrap.Modal(document.getElementById('success-dialog'));
            window.failDialog = new tabler.bootstrap.Modal(document.getElementById('fail-dialog'));
        }
    });

    if (typeof ClipboardJS !== 'undefined' && document.querySelector('.copy')) {
        var clipboard = new ClipboardJS('.copy');
        clipboard.on('success', function(e) {
            showToast('{$t.dashboard.copied}', 'success');
            e.clearSelection();
        });
        clipboard.on('error', function(e) {
            var text = e.trigger.getAttribute('data-clipboard-text');
            if (text) {
                if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(text).then(function() {
                        showToast('{$t.dashboard.copied}', 'success');
                    }).catch(function() {
                        prompt('', text);
                    });
                } else {
                    prompt('', text);
                }
            }
        });
    }

    htmx.on("htmx:afterRequest", function(evt) {
        if (evt.detail.xhr.getResponseHeader('HX-Refresh') === 'true' ||
            evt.detail.xhr.getResponseHeader('HX-Trigger')) {
            return;
        }
        try {
            var res = JSON.parse(evt.detail.xhr.response);
            if (typeof res.data !== 'undefined') {
                for (var key in res.data) {
                    if (res.data.hasOwnProperty(key)) {
                        if (key === "ga-url" && typeof qrcode !== 'undefined') {
                            qrcode.clear();
                            qrcode.makeCode(res.data[key]);
                            continue;
                        }
                        if (key === "last-checkin-time") {
                            var checkInBtn = document.getElementById("check-in");
                            if (checkInBtn) {
                                checkInBtn.textContent = "{$t.dashboard.checked_in}";
                                checkInBtn.disabled = true;
                            }
                            continue;
                        }
                        var element = document.getElementById(key);
                        if (element) {
                            if (element.tagName === "INPUT" || element.tagName === "TEXTAREA") {
                                element.value = res.data[key];
                            } else {
                                element.textContent = res.data[key];
                            }
                        }
                    }
                }
            }
            var isSuccess = res.ret === 1;
            var messageId = isSuccess ? "success-message" : "fail-message";
            var dialog = isSuccess ? window.successDialog : window.failDialog;
            document.getElementById(messageId).textContent = res.msg;
            if (dialog) {
                dialog.show();
            } else {
                showToast(res.msg, isSuccess ? 'success' : 'danger');
            }
        } catch (e) {
            showToast('Unexpected error', 'danger');
        }
    });
</script>
<script>console.table([['DB Queries', 'Execution Time'], ['{count($queryLog)} queries', '{$optTime} ms']])</script>

{include file='live_chat.tpl'}
{include file='telemetry.tpl'}

</body>
</html>
