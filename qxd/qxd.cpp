// qxd.cpp - tiny QxD interpreter: qxd file.iQxD
#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <utility>

using std::string;
using Db = std::map<std::pair<string, string>, string>;

static string trim(const string &s)
{
    const char *ws = " \t\r\n";
    size_t a = s.find_first_not_of(ws);
    if (a == string::npos) return "";
    return s.substr(a, s.find_last_not_of(ws) - a + 1);
}

static string unq(string s)
{
    if (!s.empty() && s.front() == '"') s.erase(0, 1);
    if (!s.empty() && s.back() == '"') s.pop_back();
    return s;
}

// Node[NAME].Field[.sub] -> value
static string lookup(const Db &db, const string &ref)
{
    if (ref.compare(0, 5, "Node[") != 0) return "";
    size_t c = ref.find("].");
    if (c == string::npos) return "";
    auto it = db.find({ref.substr(5, c - 5), ref.substr(c + 2)});
    if (it == db.end()) return "";
    string v = it->second;
    size_t a;
    while ((a = v.find(" -> ")) != string::npos) v = v.substr(a + 4);
    return unq(v);
}

int main(int argc, char **argv)
{
    if (argc < 2) { std::cerr << "usage: qxd file.iQxD\n"; return 1; }
    std::ifstream in(argv[1]);
    if (!in) { std::cerr << argv[1] << ": cannot open\n"; return 1; }

    Db db;
    string node, raw;
    bool inmain = false;

    while (std::getline(in, raw)) {
        string line = trim(raw);
        if (line.empty() || line.compare(0, 2, "//") == 0) continue;
        if (line.compare(0, 5, "Node[") == 0 && line.size() > 2 &&
            line.compare(line.size() - 2, 2, " {") == 0) {
            node = line.substr(5, line.find(']') - 5);
            continue;
        }
        if (line == "main {") { inmain = true; continue; }
        if (line == "}")      { node.clear(); inmain = false; continue; }

        if (inmain) {
            if (line.compare(0, 6, "print ") == 0) {
                string rest = line.substr(6), text, ref = rest;
                if (!rest.empty() && rest[0] == '"') {
                    size_t q = rest.find('"', 1);
                    if (q != string::npos) {
                        text = rest.substr(1, q - 1);
                        ref = trim(rest.substr(q + 1));
                    }
                }
                std::cout << text << (ref.empty() ? string() : lookup(db, ref)) << "\n";
            }
            continue;
        }
        if (node.empty()) continue;

        size_t colon = line.find(':');
        if (colon == string::npos) continue;
        string field = trim(line.substr(0, colon));
        string value = trim(line.substr(colon + 1));
        db[{node, field}] = value;

        // { key: val, key: val } also stores Field.key
        if (value.size() > 1 && value.front() == '{' && value.back() == '}' &&
            value.find(':') != string::npos) {
            string inner = value.substr(1, value.size() - 2);
            size_t pos = 0;
            while (pos <= inner.size()) {
                size_t comma = inner.find(',', pos);
                string pair = inner.substr(
                    pos, comma == string::npos ? string::npos : comma - pos);
                size_t pc = pair.find(':');
                if (pc != string::npos)
                    db[{node, field + "." + trim(pair.substr(0, pc))}] =
                        trim(pair.substr(pc + 1));
                if (comma == string::npos) break;
                pos = comma + 1;
            }
        }
    }
    return 0;
}
