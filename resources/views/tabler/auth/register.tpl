{include file='header.tpl'}

<body class="d-flex flex-column min-vh-100">
<div class="auth-page">
    <div class="container d-flex flex-column justify-content-center align-items-center flex-grow-1 py-5">
        <div class="w-100" style="max-width: 420px;">
            <div class="text-center mb-4">
                <a href="/" class="d-inline-flex align-items-center gap-2 text-decoration-none">
                    <img src="/images/uim-logo-round_96x96.png" height="48" alt="{$config['appName']}">
                </a>
                <h2 class="mt-3 mb-1 fw-700" style="font-size:1.5rem; letter-spacing:-0.02em;">{$t.auth.register_title}</h2>
                <p class="text-secondary mb-0" style="font-size:0.875rem;">{$config['appName']}</p>
            </div>

            <div class="card auth-card">
                <div class="card-body p-4">
                    {if $public_setting['reg_mode'] !== 'close'}
                        <div class="mb-3">
                            <label class="form-label fw-500" style="font-size:0.875rem;">{$t.auth.username}</label>
                            <input id="name" type="text" class="form-control" placeholder="John Doe" autocomplete="name">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-500" style="font-size:0.875rem;">{$t.auth.email}</label>
                            <input id="email" type="email" class="form-control" placeholder="you@example.com" autocomplete="email">
                        </div>
                        {if $public_setting['reg_email_verify']}
                        <div class="mb-3">
                            <label class="form-label fw-500" style="font-size:0.875rem;">
                                {$t.auth.email} — Verification Code
                            </label>
                            <div class="input-group">
                                <input id="emailcode" type="text" class="form-control" placeholder="6-digit code">
                                <button id="send-verify-email" class="btn btn-outline-secondary" type="button"
                                        hx-post="/auth/send" hx-swap="none" hx-disabled-elt="this"
                                        hx-vals='js:{ email: document.getElementById("email").value }'>
                                    Send
                                </button>
                            </div>
                        </div>
                        {/if}
                        <div class="mb-3">
                            <label class="form-label fw-500" style="font-size:0.875rem;">{$t.auth.password}</label>
                            <div class="input-group">
                                <input id="password" type="password" class="form-control" autocomplete="new-password">
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePasswordVisibility('password', 'pwd-eye')" tabindex="-1" style="border-radius:0 8px 8px 0;">
                                    <i class="ti ti-eye" id="pwd-eye"></i>
                                </button>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-500" style="font-size:0.875rem;">{$t.auth.confirm_password}</label>
                            <div class="input-group">
                                <input id="confirm_password" type="password" class="form-control" autocomplete="new-password">
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePasswordVisibility('confirm_password', 'cpwd-eye')" tabindex="-1" style="border-radius:0 8px 8px 0;">
                                    <i class="ti ti-eye" id="cpwd-eye"></i>
                                </button>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-500" style="font-size:0.875rem;">{$t.auth.invite_code}
                                {if $public_setting['reg_mode'] === 'open'}
                                    <span class="text-secondary fw-400">(optional)</span>
                                {else}
                                    <span class="text-danger fw-400">*</span>
                                {/if}
                            </label>
                            <input id="invite_code" type="text" class="form-control" value="{$invite_code}" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-check">
                                <input id="tos" type="checkbox" class="form-check-input"/>
                                <span class="form-check-label" style="font-size:0.875rem;">
                                    I agree to the <a href="/tos" class="fw-500">Terms of Service</a>
                                </span>
                            </label>
                        </div>
                        {if $public_setting['enable_reg_captcha']}
                        <div class="mb-3">
                            {include file='captcha/div.tpl'}
                        </div>
                        {/if}
                        <div class="d-grid">
                            <button class="btn btn-primary"
                                    hx-post="/auth/register" hx-swap="none" hx-vals='js:{
                                        {if $public_setting['reg_email_verify']}
                                            emailcode: document.getElementById("emailcode").value,
                                        {/if}
                                        {if $public_setting['enable_reg_captcha']}
                                            {include file='captcha/ajax.tpl'}
                                        {/if}
                                        name: document.getElementById("name").value,
                                        email: document.getElementById("email").value,
                                        password: document.getElementById("password").value,
                                        confirm_password: document.getElementById("confirm_password").value,
                                        invite_code: document.getElementById("invite_code").value,
                                        tos: document.getElementById("tos").checked,
                                     }'>
                                {$t.auth.register_btn}
                            </button>
                        </div>
                    {else}
                        <div class="text-center py-3">
                            <i class="ti ti-lock icon mb-3 text-secondary" style="font-size:3rem;"></i>
                            <p class="text-secondary">Registration is currently closed. Please check back later.</p>
                        </div>
                    {/if}
                </div>
            </div>

            <div class="text-center mt-3 text-secondary" style="font-size:0.875rem;">
                {$t.auth.have_account} <a href="/auth/login" class="fw-500">{$t.auth.login_link}</a>
            </div>

            <div class="text-center mt-3">
                {foreach $locale_list as $loc}
                <a href="/user/locale/{$loc}" class="text-secondary me-2" style="font-size:0.8rem; text-decoration:none;">
                    {if $loc === 'en_US'}EN{elseif $loc === 'zh_CN'}中文{elseif $loc === 'zh_TW'}繁中{elseif $loc === 'ja_JP'}日本語{else}{$loc}{/if}
                </a>
                {/foreach}
            </div>
        </div>
    </div>
</div>

<script>
    function togglePasswordVisibility(fieldId, eyeId) {
        var pwd = document.getElementById(fieldId);
        var eye = document.getElementById(eyeId);
        if (pwd.type === 'password') {
            pwd.type = 'text';
            eye.className = 'ti ti-eye-off';
        } else {
            pwd.type = 'password';
            eye.className = 'ti ti-eye';
        }
    }
</script>

{if $public_setting['enable_reg_captcha']}
    {include file='captcha/js.tpl'}
{/if}

{include file='footer.tpl'}
