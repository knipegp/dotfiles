;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Griffin Knipe" user-mail-address "knipegp@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")
(setq org-agenda-files (list org-directory))
(setq org-roam-directory (file-truename org-directory))
(setq org-roam-capture-templates '(("t" "todo" entry (file "./template_todo.org")
                                    :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                                       "#+title: ${title}\n#+tags: todo")
                                    :unnarrowed t)
                                   ("e" "event" entry (file "./template_event.org")
                                    :target(file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                                      "#+title: ${title}\n#+tags: event"))
                                   ("d" "default" plain "%?"
                                    :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                                       "#+title: ${title}\n")
                                    :unnarrowed t)))
(setq org-inbox (concat org-directory "inbox.org"))
(setq org-capture-templates '(("t" "Todo" entry (file+headline org-inbox "Tasks")
                               "* TODO %?\n    %i\n")
                              ("d" "default" entry (file+headline org-inbox "Notes")
                               "* %?\n    %i\n")
                              ("e" "event" entry (file+headline org-inbox "Events") "* %?\n
%i\n")
                              ("s" "source" entry (file+headline org-inbox "Sources")
                               "* [ ] %? %^{location}p\n")
                              ("c" "shopping cart" entry (file+headline org-inbox "Shopping Cart")
                               "* [ ] %? %^{location}p\n%^{priority}p\n")))

;; From: https://emacs.stackexchange.com/a/26120
(defun add-property-with-date-captured ()
  "Add DATE_CAPTURED property to the current item."
  (interactive)
  (org-set-property "date_captured" (format-time-string "%FT%T%z")))

(add-hook 'org-capture-before-finalize-hook 'add-property-with-date-captured)

(add-hook 'emacs-lisp-mode-hook (load "elisp-format"))
;; this determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(server-start)
