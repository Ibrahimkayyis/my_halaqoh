---
trigger: always_on
---

# Ponytail Override untuk MyHalaqoh

Ponytail YAGNI rules berlaku untuk IMPLEMENTASI DETAIL saja.
Ponytail TIDAK boleh simplifikasi:
- Layer structure (domain/data/presentation) — ini intentional, bukan over-engineering
- Hive adapter files — wajib ada meski verbose
- Repository interface + implementation — tidak boleh di-merge
- GetIt service locator registration — tidak boleh di-skip
- Cubit + State files — tidak boleh di-combine

Ponytail BOLEH berlaku untuk:
- Pemilihan widget (gunakan built-in sebelum custom)
- Simplifikasi logic dalam method
- Pengurangan nesting yang tidak perlu
- Eliminasi dead code