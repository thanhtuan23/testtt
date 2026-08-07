# Security Policy (Chính Sách Bảo Mật)

## 🛡️ Các Phiên Bản Được Hỗ Trợ (Supported Versions)

Chúng tôi tích cực cung cấp các bản cập nhật bảo mật cho các phiên bản sau:

| Phiên bản | Hỗ trợ bảo mật |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0.0 | :x:                |

---

## 📩 Báo Cáo Lỗ Hổng Bảo Mật (Reporting a Vulnerability)

Chúng tôi coi trọng an toàn thông tin và bảo mật dữ liệu. Nếu bạn phát hiện lỗ hổng bảo mật trong dự án này, vui lòng tuân thủ quy trình sau:

1. **KHÔNG** tạo Public Issue trên GitHub đối với các lỗ hổng nghiêm trọng.
2. Gửi email trực tiếp cho đội ngũ bảo mật tại: `security@example.com` với các thông tin sau:
   - Mô tả chi tiết về lỗ hổng (Vulnerability description).
   - Các bước tái hiện lỗ hổng (Proof of Concept / Steps to reproduce).
   - Mức độ ảnh hưởng ước tính (Impact assessment).
3. Đội ngũ phát triển sẽ phản hồi và xác nhận sự cố trong vòng **48 giờ**.
4. Bản vá bảo mật sẽ được phát hành sớm nhất có thể sau khi kiểm thử.

---

## 🔒 Quy Trình Bảo Mật Trong Phát Triển (Security Practices)

- Tất cả mã nguồn phải đi qua luồng **DevSecOps CI Pipeline**:
  - Quét Secret leakage bằng `Gitleaks`.
  - Phân tích tĩnh mã nguồn (SAST) & quét phụ thuộc (SCA) bằng `Trivy` & `Semgrep`.
  - Quét lỗ hổng Docker image trước khi triển khai.
  - Áp dụng nguyên tắc **Least Privilege** cho tất cả các tài khoản service/container.
