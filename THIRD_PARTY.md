# Third-party code

The repository is declared MIT in `CITATION.cff`. Several files under `src/` are
not original work. This list records what is known from the source files
themselves. **Licence terms were not independently verified**; the "Status"
column says where the file itself states terms and where someone still has to
check the original source.

## Credited in the file header

| File(s) | Original author | Source / terms stated in file |
| --- | --- | --- |
| `src/sys/cprintf.m` | Yair M. Altman | File Exchange. Header: free use/modification as long as the author is credited and attributed. |
| `src/math/derivest.m`, `gradest.m`, `jacobianest.m`, `hessest.m`, `hessdiag.m`, `directionaldiff.m` | John D'Errico | DERIVEST suite (File Exchange). No terms in the files; **check the original licence**. |
| `src/file/fullpath.m` | Jan Simon | Header: BSD, "mention the author". |
| `src/math/crossing.m` | Steffen Brueckner | File Exchange. No terms in file. |
| `src/data/allcomb.m`, `src/mat/padcat.m` | Jos van der Geest | File Exchange. Only "(c) Jos van der Geest"; **check the original licence**. |
| `src/func/isfunction.m` | Jos van der Geest | File Exchange 45778. No terms in file. |
| `src/plot/distinguishableColors.m` | Timothy E. Holy | "Copyright 2010-2011 by Timothy E. Holy". **Check the original licence.** |
| `src/sys/datestr8601.m`, `src/str/strnatsort.m`, `src/str/strnatsortfiles.m` | Stephen Cobeldick | "(c) 2015/2017 Stephen Cobeldick". **Check the original licence.** |
| `src/math/adjugate.m` | Roger Stafford | File Exchange 12692. No terms in file. |
| `src/mat/pages2blkdiag.m` | Andrei Bobrov | MATLAB Answers 481632. |
| `src/sys/git.m` | (FEX 29154 authors) | Based on File Exchange submission 29154. |
| `src/sys/computername.m` | (FEX 16450 author) | Based on File Exchange submission 16450. |
| `src/optim/newtonraphson.m` | (FEX 43097 author) | References File Exchange 43097. |

Anything taken from the File Exchange is distributed under the licence the
author chose, so the MIT declaration in `CITATION.cff` covers only the original
parts of those files.

## No attribution in the file, origin unclear

| File | Notes |
| --- | --- |
| `src/sys/dispstat.m` | Looks like the File Exchange `dispstat` ("Developed by Kasim" in the example). No author, source or licence in the file. |
| `src/plot/tightfig.m` | Looks like the File Exchange `tightfig`. No author, source or licence in the file. |
| `src/ode/ode2.m` … `ode5.m` | Fixed-step solvers in the style of Cleve Moler's. No attribution in the header. |

## MathWorks code (cannot be fixed with attribution)

These carry a MathWorks copyright notice or use MathWorks internals, and
MathWorks source is proprietary. It can't be relicensed as MIT.

| File | Evidence |
| --- | --- |
| `src/ode/private/odearguments.m` | "Copyright 1984-2017 The MathWorks, Inc." |
| `src/ode/private/odemass.m` | MathWorks `odemass` (author Jacek Kierzenka), uses `MATLAB:odemass:*` message IDs. |
| `src/funfun/deval.m` | Header lists the repo author, but the body uses `MATLAB:deval:*` message IDs and it shadows the built-in `deval`. |

`odearguments` and `odemass` are used by `src/ode/leapfrog.m` and
`src/ode/bdf.m`. They should be replaced by own implementations, or the two
solvers should be dropped from the public repository.
