;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(setq tramp-default-method "ssh")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Griffin Knipe"
      user-mail-address "knipegp@gmail.com")

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
(setq doom-font (font-spec :family "monospace" :size 14))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; (setq debug-on-message 1)
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(require 'org)
(setq org-directory "~/org/")
(setq org-log-done 'time)
(setq org-agenda-files '("~/org/slip-box" "~/org/slip-box/daily"))
(org-babel-do-load-languages 'org-babel-load-languages '((ditaa . t)))
(org-babel-do-load-languages 'org-babel-load-languages '((dot . t)))
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "booktabs"))
(add-to-list 'org-latex-packages-alist '("" "minted"))
(add-to-list 'org-latex-packages-alist '("" "bm"))
(setq org-latex-listings 'minted
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-minted-options
        '(("frame" "lines") ("linenos=true")))
(eval-after-load 'org-latex (add-to-list 'org-latex-classes "neu_msthesis"))

(with-eval-after-load 'ox-latex
   (add-to-list 'org-latex-classes
                '("thesis"
                  "\\documentclass{macro/neu_msthesis}
                  \\usepackage[utf8]{inputenc}
                  \\usepackage[T1]{fontenc}
                  \\usepackage{graphicx}
                  \\usepackage{grffile}
                  \\usepackage{wrapfig}
                  \\usepackage{longtable}
                  \\usepackage{rotating}
                  \\usepackage{amssymb}
                  \\usepackage{capt-of}
                  \\usepackage[normalem]{ulem}
                  \\usepackage{amsmath}
                  \\usepackage{textcomp}
                  \\usepackage{caption}
                  \\input{macro/macro}
                  [NO-DEFAULT-PACKAGES]"
                  ("\\chapter{%s}" . "\\chapter*{%s}")
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(map! :map visual-line-mode-map
      :m "j" 'evil-next-visual-line
      :m "k" 'evil-previous-visual-line)

(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.


 ;; From: https://github.com/abo-abo/org-download/blob/master/README.md#set-up
 ;; (require 'org-download)

(require 'org-ref)

 ;; Drag-and-drop to `dired`
 ;; (add-hook 'dired-mode-hook 'org-download-enable)
(setq reftex-default-bibliography '("~/bibliography/references.bib"))

;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/org/bibliography/notes.org"
      org-ref-default-bibliography '("~/org/bibliography/references.bib")
      org-ref-pdf-directory "~/org/bibliography/pdfs/")

(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))


(setq bibtex-completion-library-path '("~/org/bibliography"))
(setq bibtex-completion-bibliography '("~/org/bibliography/references.bib"))

(require 'org-roam-bibtex)
(add-hook 'after-init-hook #'org-roam-bibtex-mode)

(require 'org-roam)
(add-hook 'after-init-hook #'org-roam-mode)
(executable-find "sqlite3")
(setq org-roam-directory "~/org/slip-box")
(setq orb-preformat-keywords
      '("citekey" "title" "url" "author-or-editor" "keywords" "file")
      orb-process-file-keyword t
      orb-file-field-extensions '("pdf"))

(setq orb-templates
      '(("r" "ref" plain (function org-roam-capture--get-point)
         ""
         :file-name "${citekey}"
         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n#+roam_alias:\n#+roam_tags:

- tags ::
- keywords :: ${keywords}

* ${title}
:PROPERTIES:
:Custom_ID: ${citekey}
:URL: ${url}
:AUTHOR: ${author-or-editor}
:END:")))

(setq org-roam-capture-templates '(("d" "default" plain (function org-roam--capture-get-point)
     "%?"
     :file-name "%<%Y%m%d%H%M%S>-${slug}"
     :head "#+title: ${title}\n#+roam_alias:\n#+roam_tags:"
     :unnarrowed t
)))

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         #'org-roam-capture--get-point
         "* %?"
         :file-name "daily/%<%Y-%m-%d>"
         :head "#+title: Journal %<%Y-%m-%d>\n#+roam_key:%<%Y-%m-%d>\n#+roam_alias:\n#+roam_tags:

* Scheduled
* Journal
* Fleeting
")))

(add-hook 'go-mode-hook '(lambda ()
                           (setq flycheck-checker 'golangci-lint)))
(add-hook 'sh-mode-hook '(lambda ()
                           (setq flycheck-checker 'sh-shellcheck)))
(add-hook 'python-mode-hook '(lambda ()
                               (setq flycheck-checker 'python-pylint)))
(require 'lsp)
(add-hook 'python-mode-hook '(lambda()
                               (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.pytest_cache\\'")
                               (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]__pycache__\\'")
                               (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.mypy_cache\\'")))
(add-hook 'scala-mode-hook '(lambda ()
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]vlsi\\'")
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]tools\\'")
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]tests\\'")
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]software\\'")
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]sims\\'")
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]scripts\\'")
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]project\\'")
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]docs\\'")
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]target\\'")
                              (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]toolchains\\'")))

(load "latex.el" nil t t)

(load "alloy-mode.el")
(require 'alloy-mode)
(add-to-list 'auto-mode-alist '("\\.als\\'" . alloy-mode))

(setq exec-path (append exec-path '("~/.poetry/bin")))
(setq ispell-program-name "hunspell")
(setq org-ref-bibliography-entry-format '(
        ("article" . "%a, %t, <i>%j</i>, <b>%v(%n)</b>, %p (%y). <a href=\"%U\">link</a>. <a href=\"http://dx.doi.org/%D\">doi</a>.")
        ("book" . "%a, %t, %u (%y).")
        ("techreport" . "%a, %t, %i, %u (%y).")
        ("proceedings" . "%e, %t %S, %u (%y).")
        ("inproceedings" . "%a, %t, %p, %b"))
)
(provide 'config)
;;; config.el ends here
