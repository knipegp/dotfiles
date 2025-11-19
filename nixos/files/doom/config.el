;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq
 user-full-name "Griffin Knipe"
 user-mail-address "knipegp@proton.me")

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
(setq doom-font (font-spec :family "Fira Code Nerd Font" :size 14))
(setq doom-variable-pitch-font
      (font-spec :family "Fira Code Nerd Font" :size 14))
(setq doom-big-font (font-spec :family "Fira Code Nerd Font" :size 24))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

(after! org (setq org-todo-keywords
                  '((sequence "TODO(t)" "IN_PROGRESS(i)" "WAIT(w)" "|" "DONE(d)")
                    (sequence "|" "CANCELED(c)"))))
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Org/")
(setq org-agenda-files (list org-directory))
(setq org-roam-directory (file-truename org-directory))
(setq org-inbox (concat org-directory "inbox.org"))
(load "org-ql-search")
(setq org-agenda-custom-commands
      '(("c" "Custom Agenda"
         ((org-ql-block '((tags "inbox") :header "Inbox"))
          (org-ql-block
           '((and (or (todo "TODO") (todo "WAIT") (todo "IN_PROGRESS"))
                  (tags "recurring")
                  (planning 0)
                  )
             :header "Recurring"
             :sort (date priority)))
          (org-ql-block
           '((and (or (todo "TODO") (todo "WAIT") (todo "IN_PROGRESS"))
                  (tags "task")
                  (not (tags "recurring"))
                  (or (planning 30) (not (planning))))
             :header "Tasks"
             :sort (date priority)))
          (org-ql-block
           '((and (or (todo "TODO") (todo "WAIT") (todo "IN_PROGRESS"))
                  (tags "project")
                  (or (planning 30) (not (planning))))
             :header "Project"
             :sort (date priority)))
          (org-ql-block
           '((and (or (todo "TODO") (todo "WAIT") (todo "IN_PROGRESS"))
                  (tags "shopping_cart")
                  (or (planning 30) (not (planning))))
             :header "Shopping Cart"
             :sort (date priority)))
          (org-ql-block
           '((and (or (todo "TODO") (todo "WAIT") (todo "IN_PROGRESS"))
                  (tags "research")
                  (or (planning 30) (not (planning))))
             :header "Research"
             :sort (date priority)))
          (org-ql-block
           '((and (or (todo "TODO") (todo "WAIT") (todo "IN_PROGRESS"))
                  (tags "hobby")
                  (or (planning 30) (not (planning))))
             :header "Hobby"
             :sort (date priority)))
          (org-ql-block
           '((and (or (todo "TODO") (todo "WAIT") (todo "IN_PROGRESS"))
                  (tags "readme")
                  (or (planning 30) (not (planning))))
             :header "README"
             :sort (date priority)))
          (agenda)))))
;; From: https://emacs.stackexchange.com/a/26120
(defun add-property-with-date-captured ()
  "Add DATE_CAPTURED property to the current item."
  (interactive)
  (org-set-property "date_captured" (format-time-string "%FT%T%z")))

(add-hook 'org-capture-before-finalize-hook 'add-property-with-date-captured)

;; this determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq projectile-generic-command "fd . -0 --type f --color=never")
(setq rst-pdf-program "okular")

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
;; (add-to-list 'default-frame-alist '(font . "Fira Code" ))
;; (set-face-attribute 'default t :font "Fira Code" )
