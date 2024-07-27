;;; ride-mode.el --- A major-mode for editing RIDE language

;; SPDX-License-Identifier: GPL-3.0

;; Author: DEADBLACKCLOVER <deadblackclover@protonmail.com>
;; Version: 0.1.0
;; URL: https://codeberg.org/deadblackclover/ride-mode
;; Keywords: languages
;; Package-Requires: ((emacs "25.1"))

;; Copyright (c) 2024, DEADBLACKCLOVER.

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package implements a major-mode for editing smart contracts
;; written in RIDE.

;;; Code:
(defconst ride-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\' "\"" table)
    (modify-syntax-entry ?\# "< b" table)
    (modify-syntax-entry ?\n "> b" table)
    table)
  "Syntax table for the RIDE language.")

(defconst ride-mode-keyword
  '("let" "strict" "base16" "base58" "base64" "true" "false" "if" "then" "else" "match" "case" "func" "FOLD")
  "RIDE keywords.")

(defconst ride-mode-highlights
  (list
   `("\\_<let\\s-+\\([a-z][A-Za-z0-9]*\\)" 1 'font-lock-variable-name-face)
   `("\\_<func\\s-+\\([a-z][A-Za-z0-9]*\\)" 1 'font-lock-function-name-face)
   `("{-#\s[A-Z_]+\s[A-Z0-9]+\s+#-}\\|@Callable\\|@Verifier" . 'font-lock-preprocessor-face)
   `(,(regexp-opt ride-mode-keyword 'words) . 'font-lock-keyword-face)
   `("\\_<[A-Z][A-Za-z0-9]*\\_>" . 'font-lock-type-face)
   `("\\(\\_<[a-z][A-Za-z0-9]*\\_>\\)(" 1 'font-lock-function-call-face))
  "RIDE syntax highlighting with `'font-lock-mode'.")

;; Emacs < 24 did not have prog-mode
(defalias 'ride-parent-mode
  (if (fboundp 'prog-mode) #'prog-mode #'fundamental-mode))

;;;###autoload
(define-derived-mode ride-mode ride-parent-mode "RIDE"
  "Major mode for editing RIDE smart contract."
  :syntax-table ride-mode-syntax-table
  (setq-local comment-start "# ")
  (setq-local comment-end "")
  (setq-local font-lock-defaults '(ride-mode-highlights))
  ;; Directives fix
  (setq-local syntax-propertize-function (syntax-propertize-rules ("{-\\(.*\\)-}" (1 ".")))))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.ride\\'" . ride-mode))

(provide 'ride-mode)
;;; ride-mode.el ends here
