# liburlencoding-zig

[![](https://img.shields.io/github/v/tag/thechampagne/liburlencoding-zig?label=version)](https://github.com/thechampagne/liburlencoding-zig/releases/latest) [![](https://img.shields.io/github/license/thechampagne/liburlencoding-zig)](https://github.com/thechampagne/liburlencoding-zig/blob/main/LICENSE)

Zig binding for **liburlencoding**.

### API

```zig
fn encode(data: []const u8) ?[]u8;

fn encodeBinary(data: []const u8) ?[]u8;

fn decode(data: []const u8) ?[]u8;

fn decodeBinary(data: []const u8) ?[]u8;

fn free(data: ?[]u8) void;
```

### References
 - [liburlencoding](https://github.com/thechampagne/liburlencoding)

### License

This repo is released under the [MIT](https://github.com/thechampagne/liburlencoding-zig/blob/main/LICENSE).
