import os

def rename_files():
    # 获取当前脚本所在目录的mahjong_texture文件夹的路径
    directory = os.path.join(os.getcwd(), "mahjong_texture")
    
    # 检查目录是否存在
    if not os.path.exists(directory):
        print("mahjong_texture 文件夹不存在于当前目录中。")
        return
    
    # 遍历目录中的所有文件
    for filename in os.listdir(directory):
        if filename.startswith("mahjong_"):
            # 构建完整的文件路径
            old_file_path = os.path.join(directory, filename)
            # 分割文件名，查找符合条件的部分
            parts = filename.split('_')
            # 初始化索引和新文件名前缀
            index_of_last_digit = -1
            for i, part in enumerate(parts):
                if part.isdigit():
                    index_of_last_digit = i
            # 检查是否找到数字，且数字后还有内容
            if index_of_last_digit != -1 and index_of_last_digit < len(parts) - 1:
                # 构造新的文件名
                new_filename = 'mahjong_' + '_'.join(parts[index_of_last_digit + 1:])
                new_file_path = os.path.join(directory, new_filename)
                # 重命名文件
                os.rename(old_file_path, new_file_path)
                print(f"文件 {filename} 已重命名为 {new_filename}")
            else:
                print(f"文件 {filename} 不符合命名规则，未进行重命名。")

# 运行重命名函数
rename_files()
