/* ===== Site.js — Vanilla JS, No Libraries ===== */

(function () {
    'use strict';

    /* ---------- Toast Notifications ---------- */
    function showToast(message, isError) {
        var container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container';
            document.body.appendChild(container);
        }
        var toast = document.createElement('div');
        toast.className = 'toast' + (isError ? ' toast-error' : '');
        toast.textContent = message;
        container.appendChild(toast);
        setTimeout(function () {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(40px)';
            toast.style.transition = '0.3s ease';
            setTimeout(function () { toast.remove(); }, 300);
        }, 2500);
    }

    /* ---------- Mobile Nav Toggle ---------- */
    function initNav() {
        var toggle = document.querySelector('.nav-toggle');
        var links = document.querySelector('.nav-links');
        if (toggle && links) {
            toggle.addEventListener('click', function () {
                links.classList.toggle('open');
            });
        }
    }

    /* ---------- Tabs ---------- */
    function initTabs() {
        var tabBtns = document.querySelectorAll('.tab-nav button');
        for (var i = 0; i < tabBtns.length; i++) {
            tabBtns[i].addEventListener('click', function () {
                var target = this.getAttribute('data-tab');
                var parent = this.closest('.tabs');
                var allBtns = parent.querySelectorAll('.tab-nav button');
                var allPanes = parent.querySelectorAll('.tab-pane');
                for (var j = 0; j < allBtns.length; j++) allBtns[j].classList.remove('active');
                for (var k = 0; k < allPanes.length; k++) allPanes[k].classList.remove('active');
                this.classList.add('active');
                var pane = parent.querySelector('#' + target);
                if (pane) pane.classList.add('active');
            });
        }
    }

    /* ---------- Form Validation ---------- */
    function validateField(input) {
        var value = input.value.trim();
        var errorEl = input.parentElement.querySelector('.form-error');
        var valid = true;

        if (input.hasAttribute('required') && value === '') {
            valid = false;
            if (errorEl) { errorEl.textContent = 'This field is required.'; errorEl.classList.add('show'); }
        } else if (input.type === 'email' && value !== '' && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
            valid = false;
            if (errorEl) { errorEl.textContent = 'Enter a valid email address.'; errorEl.classList.add('show'); }
        } else if (input.getAttribute('data-minlength') && value.length < parseInt(input.getAttribute('data-minlength'))) {
            valid = false;
            if (errorEl) { errorEl.textContent = 'Minimum ' + input.getAttribute('data-minlength') + ' characters required.'; errorEl.classList.add('show'); }
        } else {
            if (errorEl) { errorEl.textContent = ''; errorEl.classList.remove('show'); }
        }

        if (valid) { input.classList.remove('error'); } else { input.classList.add('error'); }
        return valid;
    }

    function validatePasswordMatch(form) {
        var pass = form.querySelector('#password');
        var confirm = form.querySelector('#confirmPassword');
        if (pass && confirm && confirm.value.trim() !== '') {
            var errorEl = confirm.parentElement.querySelector('.form-error');
            if (pass.value !== confirm.value) {
                confirm.classList.add('error');
                if (errorEl) { errorEl.textContent = 'Passwords do not match.'; errorEl.classList.add('show'); }
                return false;
            } else {
                confirm.classList.remove('error');
                if (errorEl) { errorEl.textContent = ''; errorEl.classList.remove('show'); }
            }
        }
        return true;
    }

    function initFormValidation() {
        var forms = document.querySelectorAll('[data-validate]');
        for (var i = 0; i < forms.length; i++) {
            (function (form) {
                form.addEventListener('submit', function (e) {
                    e.preventDefault();
                    var inputs = form.querySelectorAll('.form-control[required], .form-control[data-minlength], .form-control[type="email"]');
                    var allValid = true;
                    for (var j = 0; j < inputs.length; j++) {
                        if (!validateField(inputs[j])) allValid = false;
                    }
                    if (!validatePasswordMatch(form)) allValid = false;

                    var checkbox = form.querySelector('input[type="checkbox"][required]');
                    if (checkbox && !checkbox.checked) {
                        allValid = false;
                        showToast('Please accept the terms.', true);
                    }

                    if (allValid) {
                        showToast('Success! (No backend — demo only)');
                        form.reset();
                    }
                });

                var inputs = form.querySelectorAll('.form-control');
                for (var k = 0; k < inputs.length; k++) {
                    inputs[k].addEventListener('blur', function () { validateField(this); });
                }
            })(forms[i]);
        }
    }

    /* ---------- Filter Checkboxes (Products page) ---------- */
    function initFilters() {
        var checkboxes = document.querySelectorAll('.filter-group input[type="checkbox"]');
        for (var i = 0; i < checkboxes.length; i++) {
            checkboxes[i].addEventListener('change', function () {
                var checked = [];
                var allBoxes = document.querySelectorAll('.filter-group input[type="checkbox"]:checked');
                for (var j = 0; j < allBoxes.length; j++) {
                    checked.push(allBoxes[j].value.toLowerCase());
                }

                var cards = document.querySelectorAll('[data-category]');
                for (var k = 0; k < cards.length; k++) {
                    if (checked.length === 0) {
                        cards[k].style.display = '';
                    } else {
                        var cat = cards[k].getAttribute('data-category').toLowerCase();
                        cards[k].style.display = checked.indexOf(cat) > -1 ? '' : 'none';
                    }
                }
            });
        }
    }

    /* ---------- Init on DOM Ready ---------- */
    document.addEventListener('DOMContentLoaded', function () {
        initNav();
        initTabs();
        initFormValidation();
        initFilters();
    });

})();
