-- CAU 1-2: 
CREATE TABLE MATHANG (
    MaMatHang VARCHAR2(10) PRIMARY KEY,
    TenMatHang VARCHAR2(50),
    Loai VARCHAR2(20),
    ChatLieu VARCHAR2(50),
    DonGia NUMBER,
    CONSTRAINT CK_MaMatHang CHECK (MaMatHang LIKE 'MH%')
);


CREATE TABLE HOADONBANHANG (
    MaHoaDon VARCHAR2(10) PRIMARY KEY,
    NgayDatHang DATE,
    NgayGiaoHang DATE,
    MaNguoiGiaoHang VARCHAR2(10),
    CONSTRAINT CK_MaHoaDon CHECK (MaHoaDon LIKE 'HD%'),
    CONSTRAINT FK_HoaDon_NguoiGiaoHang FOREIGN KEY (MaNguoiGiaoHang) REFERENCES NGUOIGIAOHANG(MaNguoiGiaoHang)
);


CREATE TABLE CHITIETHOADON (
    MaHoaDon VARCHAR2(10),
    MaMatHang VARCHAR2(10),
    SoLuong NUMBER,
    GiamGia NUMBER,
    DonGia NUMBER,
    PRIMARY KEY (MaHoaDon, MaMatHang),
    CONSTRAINT FK_ChiTietHoaDon_HoaDon FOREIGN KEY (MaHoaDon) REFERENCES HOADONBANHANG(MaHoaDon),
    CONSTRAINT FK_ChiTietHoaDon_MatHang FOREIGN KEY (MaMatHang) REFERENCES MATHANG(MaMatHang)
);


CREATE TABLE NGUOIGIAOHANG (
    MaNguoiGiaoHang VARCHAR2(10) PRIMARY KEY,
    CongTy VARCHAR2(50),
    SoDienThoai VARCHAR2(15),
    CONSTRAINT CK_MaNguoiGiaoHang CHECK (MaNguoiGiaoHang LIKE 'Sh%')
);

--CAU 3:

INSERT INTO MATHANG(MaMatHang, TenMatHang, Loai, ChatLieu, DonGia) VALUES ('MH00111', 'Pigeon', '160ml', 'Nhua PP', 355000);
INSERT INTO MATHANG(MaMatHang, TenMatHang, Loai, ChatLieu, DonGia) VALUES ('MH00123', 'Comotomo', '125ml', 'Silicon', 338000);
INSERT INTO MATHANG(MaMatHang, TenMatHang, Loai, ChatLieu, DonGia) VALUES ('MH00127', 'Hegen', '125ml', 'Nhua PPSU', 450000);
INSERT INTO MATHANG(MaMatHang, TenMatHang, Loai, ChatLieu, DonGia) VALUES ('MH00222', 'Avent', '240ml', 'Nhua PP', 230000);
INSERT INTO MATHANG(MaMatHang, TenMatHang, Loai, ChatLieu, DonGia) VALUES ('MH00321', 'Pigeon', '240ml', 'Thuy tinh', 380000);


INSERT INTO HOADONBANHANG(MaHoaDon, NgayDatHang, NgayGiaoHang, MaNguoiGiaoHang) VALUES ('HD001', TO_DATE('27/2/2022', 'DD/MM/YYYY'), TO_DATE('28/2/2022', 'DD/MM/YYYY'), 'Sh02TK');
INSERT INTO HOADONBANHANG(MaHoaDon, NgayDatHang, NgayGiaoHang, MaNguoiGiaoHang) VALUES ('HD002', TO_DATE('5/3/2022', 'DD/MM/YYYY'), TO_DATE('5/3/2022', 'DD/MM/YYYY'), 'Sh01VP');
INSERT INTO HOADONBANHANG(MaHoaDon, NgayDatHang, NgayGiaoHang, MaNguoiGiaoHang) VALUES ('HD003', TO_DATE('10/3/2022', 'DD/MM/YYYY'), TO_DATE('12/3/2022', 'DD/MM/YYYY'), 'Sh02TK');


INSERT INTO CHITIETHOADON(MaHoaDon, MaMatHang, SoLuong, GiamGia, DonGia) VALUES ('HD001', 'MH00111', 01, 0.5, 355000);
INSERT INTO CHITIETHOADON(MaHoaDon, MaMatHang, SoLuong, GiamGia, DonGia) VALUES ('HD001', 'MH00321', 02, 0.5, 380000);
INSERT INTO CHITIETHOADON(MaHoaDon, MaMatHang, SoLuong, GiamGia, DonGia) VALUES ('HD008', 'MH00222', 02, 0.5, 230000);
INSERT INTO CHITIETHOADON(MaHoaDon, MaMatHang, SoLuong, GiamGia, DonGia) VALUES ('HD012', 'MH00127', 01, 0.5, 450000);


INSERT INTO NGUOIGIAOHANG(MaNguoiGiaoHang, CongTy, SoDienThoai) VALUES ('Sh01VP', 'Viettel Post', '032111234');
INSERT INTO NGUOIGIAOHANG(MaNguoiGiaoHang, CongTy, SoDienThoai) VALUES ('Sh02TK', 'Giaohangtietkiem(GHTK)', '0911222123');
INSERT INTO NGUOIGIAOHANG(MaNguoiGiaoHang, CongTy, SoDienThoai) VALUES ('Sh08VP', 'Viettel Post', '0985123456');



--cau 4
CREATE OR REPLACE PROCEDURE CapNhatDonGiaSauGiam IS
BEGIN
    FOR r IN (
        SELECT MaHoaDon, MaMatHang, DonGia, GiamGia
        FROM CHITIETHOADON
        WHERE GiamGia IS NOT NULL
    ) LOOP
        UPDATE CHITIETHOADON
        SET DonGia = r.DonGia * (1 - r.GiamGia / 100)
        WHERE MaHoaDon = r.MaHoaDon AND MaMatHang = r.MaMatHang;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('?ã c?p nh?t c?t DonGia theo ph?n tr?m gi?m giá.');
END;

EXEC CapNhatDonGiaSauGiam;



-- cau 5
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE DanhSachMatHang_TheoLoai(
    p_loai IN MATHANG.Loai%TYPE
) IS
    CURSOR c_loai IS 
        SELECT *
        FROM MATHANG 
        WHERE Loai = p_loai
        ORDER BY MaMatHang;
    
    l_found BOOLEAN := FALSE;
    
BEGIN
    FOR r IN (SELECT *
        FROM MATHANG 
        WHERE Loai = p_loai
        ORDER BY MaMatHang) LOOP
        DBMS_OUTPUT.PUT_LINE('Loai: ' || r.Loai || 
                             ', MaMatHang: ' || r.MaMatHang || 
                             ', TenMatHang: ' || r.TenMatHang || 
                             ', ChatLieu: ' || r.ChatLieu || 
                             ', DonGia: ' || r.DonGia);
        l_found := TRUE;
    END LOOP;
    
    IF NOT l_found THEN
        DBMS_OUTPUT.PUT_LINE('Khong co mat hang tra ve');
    END IF;
END;

EXEC DanhSachMatHang_TheoLoai('&Loai');






--cau 6
DECLARE
    maNguoiGiaoHang VARCHAR2(10); 
    soDienThoai VARCHAR2(15);
    congTy VARCHAR2(50);
    tongSoLuotGiaoHang NUMBER;
BEGIN
    maNguoiGiaoHang := '&magh'; 

    SELECT NG.SoDienThoai, NG.CongTy, NVL(COUNT(HD.MaHoaDon), 0)
    INTO soDienThoai, congTy, tongSoLuotGiaoHang
    FROM NGUOIGIAOHANG NG
    LEFT JOIN HOADONBANHANG HD ON NG.MaNguoiGiaoHang = HD.MaNguoiGiaoHang
    WHERE NG.MaNguoiGiaoHang = maNguoiGiaoHang
    GROUP BY NG.SoDienThoai, NG.CongTy;

    DBMS_OUTPUT.PUT_LINE('So dien thoai: ' || soDienThoai);
    DBMS_OUTPUT.PUT_LINE('Cong ty: ' || congTy);
    DBMS_OUTPUT.PUT_LINE('Tong so luot giao hang: ' || tongSoLuotGiaoHang);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong co du lieu cho ma nguoi giao hang: ' || maNguoiGiaoHang);
END;

--cau 7
CREATE OR REPLACE PROCEDURE TongHoaDon_GiaoVaoNgay(
    ngay_nhap DATE
) IS
    total_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO total_count
    FROM HOADONBANHANG
    WHERE NgayDatHang = ngay_nhap;

    DBMS_OUTPUT.PUT_LINE('T?ng s? hóa ??n ???c giao vào ngày ' || TO_CHAR(ngay_nhap, 'DD/MM/YYYY') || ' là: ' || total_count);
END;


--cau 8 
CREATE OR REPLACE PROCEDURE ThongTinHoaDon(
    p_ma_hoa_don IN HOADONBANHANG.MaHoaDon%TYPE
) IS
    v_ngay_dat_hang DATE;
    v_ma_nguoi_giao_hang VARCHAR2(50);
    v_ten_nguoi_giao_hang VARCHAR2(50);
    v_tong_tien NUMBER := 0;
    
BEGIN
    SELECT NgayDatHang, MaNguoiGiaoHang
    INTO v_ngay_dat_hang, v_ma_nguoi_giao_hang
    FROM HOADONBANHANG
    WHERE MaHoaDon = p_ma_hoa_don;
    
    SELECT CongTy
    INTO v_ten_nguoi_giao_hang
    FROM NGUOIGIAOHANG
    WHERE MaNguoiGiaoHang = v_ma_nguoi_giao_hang;
    
    FOR r IN (
        SELECT SoLuong, DonGia, NVL(GiamGia, 0) AS GiamGia
        FROM CHITIETHOADON
        WHERE MaHoaDon = p_ma_hoa_don
    ) LOOP
        v_tong_tien := v_tong_tien + (r.SoLuong * (r.DonGia - r.GiamGia));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Ngay Dat Hang: ' || TO_CHAR(v_ngay_dat_hang, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('Nguoi Giao Hang: ' || v_ten_nguoi_giao_hang);
    DBMS_OUTPUT.PUT_LINE('Tong Tien: ' || v_tong_tien);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong tim thay hoa don voi ma: ' || p_ma_hoa_don);
END;

EXEC ThongTinHoaDon('&MAHOADON');







