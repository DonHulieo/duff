
---@class CKDTree
---@field root integer? The ID of the root node.
---@field dims integer? The number of dimensions.
---@field nodes {point: vector|number[], depth: integer, left: integer?, right: integer?, removed: boolean?}[] The nodes of the KD-Tree.
---@field private new_node fun(tree: CKDTree, point: vector|number[], depth: integer): integer Create a new node in the KD-Tree.
---@field private get_height fun(tree: CKDTree, root_id: integer): integer Get the height of the KD-Tree.
---@field private is_balanced fun(tree: CKDTree, root_id: integer): boolean Check if the KD-Tree is balanced. <br> A KD-Tree is balanced if the height of the left and right subtrees of every node differ by at most 1.
---@field private vector_axis {[string]: integer} The axes of a vector.
---@field private len fun(t: vector|number[]): integer Returns the length of a vector or array.
---@field private less_than fun(a: vector|number[], b: vector|number[], axis: integer): boolean Returns whether the first point is less than the second point on the specified axis.
---@field private get_dir fun(target: vector|number[], point: vector|number[], axis: integer): 'left'|'right' Returns the direction of the target point relative to the comparison point.
---@field private insert_node fun(tree: CKDTree, root_id: integer?, point: vector|number[], depth: integer): integer Insert a node into the KD-Tree.
---@field private get_nodes fun(tree: CKDTree): (vector|number[])[] Get all points in the KD-Tree.
---@field private unpack fun(t: any[], i: integer, j: integer?): ... Unpack an array.
---@field private get_dist fun(a: vector|number[], b: vector|number[]): number Get the euclidean distance between two points.
---@field private are_points_equal fun(a: vector|number[], b: vector|number[], margin: number?): boolean Check if two points are equal. <br> If a margin is provided, the points are considered equal if the distance between them is less than the margin. <br> Default: `1e-10`.
---@field private search_node fun(tree: CKDTree, root_id: integer, target: vector|number[], depth: integer, margin: number?): integer? Search for a point in the KD-Tree.
---@field private get_min_node fun(tree: CKDTree, root_id: integer): integer? Get the ID of the minimum node in the KD-Tree.
---@field private unpack_to_string fun(v: any, sep: string): string Convert a value to a string.
---@field new fun(dims: integer?): CKDTree Creates a new KD-Tree instance. <br> If `dims` is provided, it is used as the number of dimensions. <br> Otherwise, the number of dimensions is determined by the first point inserted.
---@field build fun(points: (vector|number[])[]|CKDTree): CKDTree Build a KD-Tree from a tree or list of points. <br> The first point is used to determine the number of dimensions. <br> Time complexity: `O(n log2(n))`.
---@field insert fun(tree: CKDTree, target: vector|number[]) Insert a point into the KD-Tree. <br> The first point inserted determines the number of dimensions. <br> `target` can either be a vector or an array of numbers. <br> Time complexity: `O(log2(n))`.
---@field contains fun(tree: CKDTree, target: vector|number[], margin: number?): boolean, integer? Check if the KD-Tree contains a point. <br> `target` can either be a vector or an array of numbers. <br> If `margin` is provided, the distance between the target and a point must be less than the margin. <br> Time complexity: `O(log2(n))`.
---@field remove fun(tree: CKDTree, target: vector|number[], margin: number?): boolean, integer? Remove a point from the KD-Tree. <br> `target` can either be a vector or an array of numbers. <br> If `margin` is provided, the distance between the target and a point must be less than the margin. <br> **Note** This will unbalance the tree. <br> Time complexity: `O(log2(n))`.
---@field neighbour fun(tree: CKDTree, target: vector|number[]): vector|number[], number Returns the closest point to a target point. <br> `target` can either be a vector or an array of numbers. <br> Time complexity: `O(log2(n))`.
---@field neighbours fun(tree: CKDTree, target: vector|number[], radius: number?, k: integer?): {dist: number, coords: vector|number[]}[] Returns the `k` closest points to a target point. <br> If `radius` is provided, only points within that radius are returned.
---@field range fun(tree: CKDTree, min: vector|number[], max: vector|number[]): (vector|number[])[]? Returns all points within a range. <br> The range is defined by a minimum and maximum point.
---@field tofile fun(tree: CKDTree, path: string): boolean Save the KD-Tree to a file. <br> The path should be dot-notated relative to the resource folder.
---@field fromfile fun(path: string): CKDTree Load a KD-Tree from a file. <br> The path should be dot-notated relative to the resource folder.
do
  local math, table = math, table
  local sqrt, abs = math.sqrt, math.abs
  local type, error = type, error
  local setmeta = setmetatable
  local curr_res = GetCurrentResourceName()

  ---@param tree CKDTree The KD-Tree.
  ---@param point vector|number[] The point to insert.
  ---@param depth integer The depth of the current node.
  ---@return integer node_id The ID of the new node.
  local function new_node(tree, point, depth)
    local n = #tree.nodes + 1
    tree.nodes[n] = {point = point, depth = depth, left = nil, right = nil}
    return n
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param root_id integer The ID of the root node.
  ---@return integer height The height of the KD-Tree.
  local function get_height(tree, root_id)
    if not root_id then return 0 end
    local node = tree.nodes[root_id]
    local left = get_height(tree, node.left)
    local right = get_height(tree, node.right)
    return 1 + (left > right and left or right)
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param root_id integer The ID of the root node.
  ---@return boolean is_balanced Whether the KD-Tree is balanced.
  local function is_balanced(tree, root_id)
    if not root_id then return true end
    local node = tree.nodes[root_id]
    local left = get_height(tree, node.left)
    local right = get_height(tree, node.right)
    return abs(left - right) <= 1 and is_balanced(tree, node.left) and is_balanced(tree, node.right)
  end

  ---@enum (key) vector_axis The axes of a vector.
  local vector_axis = {['vector2'] = 2, ['vector3'] = 3, ['vector4'] = 4}

  ---@param t vector|number[] The vector or array to get the length of.
  ---@return integer The length of the vector or array.
  local function len(t)
    return vector_axis[type(t)] or #t
  end

  ---@param a vector|number[] The first vector or array to compare.
  ---@param b vector|number[] The second vector or array to compare.
  ---@param axis integer The axis to compare.
  ---@return boolean is_less Whether `a` is less than `b` on the specified axis.
  local function less_than(a, b, axis)
    return a[axis] < b[axis]
  end

  ---@param target vector|number[] The target point.
  ---@param point vector|number[] The point to compare.
  ---@param axis integer The axis to compare.
  ---@return 'left'|'right' dir The direction of the target point relative to the comparison point.
  local function get_dir(target, point, axis)
    return less_than(target, point, axis) and 'left' or 'right'
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param root_id integer? The ID of the root node.
  ---@param point vector|number[] The point to insert.
  ---@param depth integer The depth of the current node.
  ---@return integer node_id The ID of the new node.
  local function insert_node(tree, root_id, point, depth)
    if not root_id then return new_node(tree, point, depth) end
    local node = tree.nodes[root_id]
    local next_point = node.point
    local dir = get_dir(point, next_point, (depth % tree.dims) + 1)
    node[dir] = insert_node(tree, node[dir], point, depth + 1)
    return root_id
  end

  ---@param tree CKDTree The KD-Tree.
  ---@return (vector|number[])[] nodes The points of the KD-Tree.
  local function get_nodes(tree, root_id, nodes)
    nodes = nodes or {}
    if not root_id then return nodes end
    local node = tree.nodes[root_id]
    nodes[#nodes + 1] = node.point
    return get_nodes(tree, node.left, get_nodes(tree, node.right, nodes))
  end

  ---@param t any[] The array to unpack.
  ---@param i integer The starting index.
  ---@param j integer? The ending index.
  ---@return ... The unpacked values.
  local function unpack(t, i, j)
    i = i or 1
    j = j or #t
    if i <= j then return t[i], unpack(t, i + 1, j) end
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param dims integer The number of dimensions.
  ---@param next_points (vector|number[])[] The points to build the KD-Tree from.
  ---@param depth integer The depth of the current node.
  ---@return CKDTree tree The KD-Tree.
  local function build_tree(tree, dims, next_points, depth)
    local l, r = 1, #next_points
    if r == 0 then return tree end
    local axis = (depth % dims) + 1
    table.sort(next_points, function(a, b) return less_than(a, b, axis) end)
    local m = l + ((r - l) >> 1)
    tree.root = insert_node(tree, tree.root, next_points[m], 0)
    build_tree(tree, dims, {unpack(next_points, 1, m - 1)}, depth + 1)
    build_tree(tree, dims, {unpack(next_points, m + 1, r)}, depth + 1)
    return tree
  end

  ---@param tree CKDTree|(vector|number[])[] The KD-Tree or points to build the KD-Tree from.
  ---@return CKDTree tree The KD-Tree.
  local function build(tree)
    local nodes = tree?.root and get_nodes(tree, tree.root, {}) or tree
    local dims = tree?.dims or len(nodes[1])
    return build_tree(NewTree(dims), dims, nodes, 0)
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param target vector|number[] The target point.
  local function insert(tree, target) -- **Note** This can unbalance the tree after multiple insertions, use `build` to rebalance.
    tree.dims = tree.dims or len(target)
    tree.root = insert_node(tree, tree.root, target, 0)
  end

  ---@param a vector|number[] The first vector or array.
  ---@param b vector|number[] The second vector or array.
  ---@return number dist The euclidean distance between the two points.
  local function get_dist(a, b)
    local r, dist = len(a), 0
    for i = 1, r do dist += (a[i] - b[i])^2 end
    return sqrt(dist)
  end

  ---@param a vector|number[] The first vector or array.
  ---@param b vector|number[] The second vector or array.
  ---@param margin number? The margin of error for the equality.
  ---@return boolean eqal Whether the two points are equal.
  local function are_points_equal(a, b, margin)
    margin = margin or 1e-10
    local r = len(a)
    for i = 1, r do
      local diff = a[i] - b[i]
      if diff < -margin or diff > margin then return false end
    end
    return true
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param root_id integer The ID of the root node.
  ---@param target vector|number[] The target point.
  ---@param depth integer The depth of the current node.
  ---@param margin number? The margin of error for the search. <br> If the distance between the target and a point is greater than the margin, the point is not found. <br> Default: `1e-10`.
  ---@return integer? root_id The ID of the node containing the target point.
  local function search_node(tree, root_id, target, depth, margin)
    if not root_id then return
    elseif are_points_equal(tree.nodes[root_id].point, target, margin) then return root_id end
    local axis = (depth % tree.dims) + 1
    local node = tree.nodes[root_id]
    local dir = get_dir(target, node.point, axis)
    return search_node(tree, node[dir], target, depth + 1)
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param target vector|number[] The target point.
  ---@param margin number? The margin of error for the search. <br> If the distance between the target and a point is greater than the margin, the point is not found. <br> Default: `1e-10`.
  ---@return boolean contains, integer? index Whether the KD-Tree contains the target point and its index.
  local function contains(tree, target, margin)
    if not tree.root then error('bad argument #1 to \'range\' (tree is empty)', 2) end
    if not target[1] then error('bad argument #2 to \'range\' (target array is empty)', 2) end
    local index = search_node(tree, tree.root, target, 0, margin)
    return index and true or false, index
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param root_id integer The ID of the node.
  ---@return integer? root_id The ID of the minimum root node.
  local function get_min_node(tree, root_id)
    local node = tree.nodes[root_id]
    if not node.left then return root_id end
    return get_min_node(tree, node.left)
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param target vector|number[] The target point.
  ---@return vector|number[]? removed, integer? node_id Whether the point was removed and its node ID.
  local function remove(tree, target) -- **Note** This will unbalance the tree, use `build` to rebalance.
    if not tree.root then error('bad argument #1 to \'range\' (tree is empty)', 2) end
    if not target[1] then error('bad argument #2 to \'remove\' (target array is empty)', 2) end
    local dims = tree.dims or len(target)
    local removed, node_id = nil, nil
    ---@param root_id integer The ID of the node.
    ---@param depth integer The depth of the current node.
    ---@return integer? root_id The ID of the removed node.
    local function remove_node(root_id, depth)
      if not root_id then return end
      local axis = (depth % dims) + 1
      local node = tree.nodes[root_id]
      local point = node.point
      if are_points_equal(point, target) then
        removed, node_id = point, root_id
        if not node.left and not node.right then node.removed = true return end
        node_id = get_min_node(tree, node.right)
        local min = tree.nodes[node_id]
        min.removed = true
        node.point = min.point
        node.right = remove_node(node.right, depth + 1)
        return root_id
      else
        local dir = get_dir(target, point, axis)
        local next_target = node[dir]
        node[dir] = remove_node(next_target, depth + 1)
      end
      return root_id
    end
    tree.root = remove_node(tree.root, 0)
    -- if not is_balanced(tree, tree.root) then build(tree) end
    return removed, node_id
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param target vector|number[] The target point.
  ---@param radius number? The maximum distance from the target point.
  ---@return vector|number[]? best, number best_dist The closest point to the target point and its distance.
  local function nearest_neighbour(tree, target, radius)
    if not tree.root then error('bad argument #1 to \'range\' (tree is empty)', 2) end
    if not target[1] then error('bad argument #2 to \'nearest_neighbour\' (target array is empty)', 2) end
    local best, best_dist = nil, radius or math.huge
    local dims = len(target)
    ---@param node_id integer? The ID of the node.
    ---@param depth integer The depth of the current node.
    ---@return vector|number[]? best, number best_dist The closest point to the target point and its distance.
    local function find_nearest(node_id, depth)
      if not node_id then return best, best_dist end
      local node = tree.nodes[node_id]
      local point = node.point
      local dist = get_dist(point, target)
      if dist < best_dist then best, best_dist = point, dist end
      local axis = (depth % dims) + 1
      local dir = get_dir(target, point, axis)
      best, best_dist = find_nearest(node[dir], depth + 1)
      if abs(target[axis] - point[axis]) < best_dist then
        best, best_dist = find_nearest(node[dir == 'left' and 'right' or 'left'], depth + 1)
      end
      return best, best_dist
    end
    return find_nearest(tree.root, 0)
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param target vector|number[] The target point.
  ---@param radius number? The maximum distance from the target point.
  ---@return {dist: number, coords: vector|number[]}[] best The closest points to the target point.
  local function nearest_neighbours(tree, target, radius)
    local dims = len(target)
    local best = {}
    local best_i = 0
    radius = radius or math.huge
    ---@param node_id integer? The ID of the node.
    ---@param depth integer The depth of the current node.
    local function find_closest_k(node_id, depth)
      if not node_id then return end
      local node = tree.nodes[node_id]
      local point = node.point
      local dist = get_dist(point, target)
      best_i += 1
      best[best_i] = {dist = dist, coords = point}
      local axis = (depth % dims) + 1
      local dir = get_dir(target, point, axis)
      find_closest_k(node[dir], depth + 1)
      if abs(target[axis] - point[axis]) < best[#best].dist then
        find_closest_k(node[dir == 'left' and 'right' or 'left'], depth + 1)
      end
    end
    find_closest_k(tree.root, 0)
    for i = #best, 1, -1 do
      if best[i] and best[i].dist >= radius then table.remove(best, i) end
    end
    return best
  end

  ---@param min vector|number[] The minimum point of the range.
  ---@param max vector|number[] The maximum point of the range.
  ---@param target vector|number[] The point to check.
  ---@param dims integer The number of dimensions.
  ---@return boolean in_range Whether the point is within the range.
  local function in_range(min, max, target, dims)
    for i = 1, dims do
      if target[i] < min[i] or target[i] > max[i] then return false end
    end
    return true
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param min vector|number[] The minimum point of the range.
  ---@param max vector|number[] The maximum point of the range.
  ---@return (vector|number[])[]? results The points within the range.
  local function range(tree, min, max)
    if not tree.root then error('bad argument #1 to \'range\' (tree is empty)', 2) end
    if not min?[1] then error('bad argument #1 to \'range\' (min array is empty)', 2) end
    if not max?[1] then error('bad argument #2 to \'range\' (max array is empty)', 2) end
    local l, r = len(min), len(max)
    local dims = l + ((r - l) >> 1)
    local results = {}
    ---@param node_id integer?
    ---@param depth integer
    ---@return (vector|number[])[]?
    local function range_search(node_id, depth)
      if not node_id then return end
      local axis = (depth % dims) + 1
      local node = tree.nodes[node_id]
      local point = node.point
      if in_range(min, max, point, dims) then results[#results + 1] = point end
      if point[axis] >= min[axis] then range_search(node.left, depth + 1) end
      if point[axis] <= max[axis] then range_search(node.right, depth + 1) end
      return results
    end
    range_search(tree.root, 0)
    return results
  end

  ---@param v any The value to convert to a string.
  ---@param sep string The separator between values.
  ---@return string str The string representation of the value.
  local function unpack_to_string(v, sep)
    local str = ''
    local length = len(v)
    for i = 1, length do
      local val = v[i]
      val = type(val) == 'string' and ("'"..val.."'") or type(val) == 'table' and '{'..unpack_to_string(val, ', ')..'}' or val
      str = str..(val..(i == length and '' or sep))
    end
    if type(v) == 'table' then
      for k, val in pairs(v) do
        if type(k) ~= 'number' then
          if type(val) == 'string' then
            str = str..sep..(k..' = \''..val..'\'')
          elseif type(val) ~= 'table' then
            str = str..sep..(k..' = '..val)
          else
            str = str..sep..(k..' = {'..unpack_to_string(val, ', ')..'}')
          end
        end
      end
    end
    return str
  end

  ---@param tree CKDTree The KD-Tree.
  ---@param path string The path to save the KD-Tree to. <br> The path should be dot-notated relative to the resource folder.
  ---@return boolean saved Whether the KD-Tree was saved successfully.
  local function to_file(tree, path)
    local file_str = 'return {\n\troot = '..tostring(tree.root)..',\n\tdims = '..tostring(tree.dims)..',\n\tnodes = {\n'
    local nodes = tree.nodes
    local length = #nodes
    for i = 1, length do
      local node = tree.nodes[i]
      local point = type(node.point) == 'table' and '{'..unpack_to_string(node.point, ', ')..'}' or 'vector'..len(node.point)..'('..unpack_to_string(node.point, ', ')..')'
      file_str = file_str..'\t\t{\n\t\t\tpoint = '..point..',\n\t\t\tdepth = '..node.depth..',\n\t\t\tleft = '..tostring(node.left)..',\n\t\t\tright = '..tostring(node.right)..'\n\t\t}'..(i == length and '' or ',')..'\n'
    end
    file_str = file_str..'\t}\n}'
    return SaveResourceFile(curr_res, path:gsub('%.', '/')..'.lua', file_str, -1) == 1
  end

  local _mt = {
    __index = {
      build = build,
      insert = insert,
      remove = remove,
      contains = contains,
      neighbour = nearest_neighbour,
      neighbours = nearest_neighbours,
      range = range,
      tofile = to_file,
    }
  }

  ---@param dims integer? The number of dimensions.
  ---@return CKDTree tree The KD-Tree.
  function NewTree(dims)
    local o = {}
    o.root = nil
    o.dims = dims
    o.nodes = {}
    return setmeta(o, _mt)
  end

  ---@param path string The path to load the KD-Tree from. <br> The path should be dot-notated relative to the resource folder.
  ---@return CKDTree tree The KD-Tree.
  local function from_file(path)
    path = '/'..path:gsub('%.', '/')..'.lua'
    local file = LoadResourceFile(curr_res, path)
    if not file then error('bad argument #1 to \'fromfile\' (file not found)', 2) end
    local tree, err = load(file, '@@'..curr_res..path, 't')
    if not tree or err then error('bad argument #1 to \'fromfile\' (file is invalid)\n\t'..err, 2) end
    return setmeta(tree(), _mt)
  end

  return {
    new = NewTree,
    build = build,
    insert = insert,
    remove = remove,
    contains = contains,
    neighbour = nearest_neighbour,
    neighbours = nearest_neighbours,
    range = range,
    tofile = to_file,
    fromfile = from_file,
  }
end