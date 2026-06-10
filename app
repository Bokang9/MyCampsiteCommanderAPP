sealed class Screen {
    data object Splash : Screen()
    data object Main : Screen()
    data object AddGear : Screen()
    data object Checklist : Screen()
}

@Composable
fun CampsiteCommanderApp() {
    // PARALLEL ARRAYS - stores gear data as per assignment
    val itemNames = remember { mutableStateListOf("Tent", "Marshmallows", "Flashlight") }
    val itemCategories = remember { mutableStateListOf("Shelter", "Food", "Safety") }
    val itemQuantities = remember { mutableStateListOf(1, 3, 2) }
    val itemComments = remember { mutableStateListOf("4-person waterproof", "For S'mores (Mega size)", "Check batteries (AA)") }

    // Navigation state
    var currentScreen by remember { mutableStateOf<Screen>(Screen.Splash) }

    // Dark nature-themed colors
    val bgGradient = Brush.verticalGradient(
        colors = listOf(Color(0xFF1B262C), Color(0xFF0F4C75), Color(0xFF3282B8))
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(bgGradient)
    ) {
        when (currentScreen) {
            is Screen.Splash -> SplashScreen(
                onTimeout = { currentScreen = Screen.Main }
            )
            is Screen.Main -> MainScreen(
                itemQuantities = itemQuantities,
                onAddClick = { currentScreen = Screen.AddGear },
                onViewClick = { currentScreen = Screen.Checklist }
            )
            is Screen.AddGear -> AddGearScreen(
                itemNames = itemNames,
                itemCategories = itemCategories,
                itemQuantities = itemQuantities,
                itemComments = itemComments,
                onBackClick = { currentScreen = Screen.Main }
            )
            is Screen.Checklist -> ChecklistScreen(
                itemNames = itemNames,
                itemCategories = itemCategories,
                itemQuantities = itemQuantities,
                itemComments = itemComments,
                onBackClick = { currentScreen = Screen.Main }
            )
        }
    }
}

@Composable
fun SplashScreen(onTimeout: () -> Unit) {
    LaunchedEffect(Unit) {
        delay(3000)
        onTimeout()
    }

    Column(
        modifier = Modifier.fillMaxSize().padding(32.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = "⛺", fontSize = 80.sp)
        Spacer(modifier = Modifier.height(16.dp))
        Text(
            text = "Campsite Commander",
            fontSize = 36.sp,
            fontWeight = FontWeight.Bold,
            color = Color.White,
            textAlign = TextAlign.Center
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = "Packing for the wild...",
            fontSize = 16.sp,
            color = Color.White.copy(alpha = 0.7f)
        )
    }
}

@Composable
fun MainScreen(
    itemQuantities: List<Int>,
    onAddClick: () -> Unit,
    onViewClick: () -> Unit
) {
    var totalItems = 0
    for (qty in itemQuantities) {
        totalItems += qty
    }

    Column(
        modifier = Modifier.fillMaxSize().padding(24.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = "Campsite Commander", fontSize = 32.sp, fontWeight = FontWeight.Bold, color = Color.White)
        Spacer(modifier = Modifier.height(40.dp))
        Surface(
            color = Color.White.copy(alpha = 0.95f),
            shape = RoundedCornerShape(16.dp),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(modifier = Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                Text(text = "Total Items Packed", fontSize = 18.sp, color = Color(0xFF1B262C))
                Text(text = "$totalItems", fontSize = 56.sp, fontWeight = FontWeight.Bold, color = Color(0xFF0F4C75))
            }
        }
        Spacer(modifier = Modifier.height(32.dp))
        Button(
            onClick = onAddClick,
            modifier = Modifier.fillMaxWidth().height(56.dp),
            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF3282B8)),
            shape = RoundedCornerShape(12.dp)
        ) {
            Icon(Icons.Default.Add, contentDescription = null)
            Spacer(Modifier.width(8.dp))
            Text("Add Gear", fontSize = 18.sp, color = Color.White)
        }
        Spacer(modifier = Modifier.height(12.dp))
        Button(
            onClick = onViewClick,
            modifier = Modifier.fillMaxWidth().height(56.dp),
            colors = ButtonDefaults.buttonColors(containerColor = Color.White),
            shape = RoundedCornerShape(12.dp)
        ) {
            Icon(Icons.Default.List, contentDescription = null)
            Spacer(Modifier.width(8.dp))
            Text("View Checklist", fontSize = 18.sp, color = Color(0xFF0F4C75))
        }
    }
}

@Composable
fun AddGearScreen(
    itemNames: MutableList<String>,
    itemCategories: MutableList<String>,
    itemQuantities: MutableList<Int>,
    itemComments: MutableList<String>,
    onBackClick: () -> Unit
) {
    var name by remember { mutableStateOf("") }
    var category by remember { mutableStateOf("Shelter") }
    var quantityText by remember { mutableStateOf("") }
    var comment by remember { mutableStateOf("") }
    var errorMessage by remember { mutableStateOf("") }

    val categories = listOf("Shelter", "Cooking", "Food", "Safety", "First Aid")

    Column(
        modifier = Modifier.fillMaxSize().padding(24.dp).verticalScroll(rememberScrollState()),
        verticalArrangement = Arrangement.Top
    ) {
        Text(text = "Add New Gear", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Color.White)
        Spacer(modifier = Modifier.height(24.dp))
        if (errorMessage.isNotEmpty()) {
            Surface(color = Color(0xFFFF5252), shape = RoundedCornerShape(8.dp), modifier = Modifier.fillMaxWidth()) {
                Text(text = errorMessage, color = Color.White, modifier = Modifier.padding(12.dp), textAlign = TextAlign.Center)
            }
            Spacer(modifier = Modifier.height(12.dp))
        }
        OutlinedTextField(
            value = name,
            onValueChange = { name = it },
            label = { Text("Item Name", color = Color.White.copy(alpha = 0.7f)) },
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(focusedTextColor = Color.White, unfocusedTextColor = Color.White)
        )
        Spacer(modifier = Modifier.height(12.dp))
        var expanded by remember { mutableStateOf(false) }
        Box {
            OutlinedButton(onClick = { expanded = true }, modifier = Modifier.fillMaxWidth()) {
                Text("Category: $category", color = Color.White)
            }
            DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
                categories.forEach { cat ->
                    DropdownMenuItem(text = { Text(cat) }, onClick = { category = cat; expanded = false })
                }
            }
        }
        Spacer(modifier = Modifier.height(12.dp))
        OutlinedTextField(
            value = quantityText,
            onValueChange = { quantityText = it },
            label = { Text("Quantity", color = Color.White.copy(alpha = 0.7f)) },
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(focusedTextColor = Color.White, unfocusedTextColor = Color.White)
        )
        Spacer(modifier = Modifier.height(12.dp))
        OutlinedTextField(
            value = comment,
            onValueChange = { comment = it },
            label = { Text("Comments/Notes", color = Color.White.copy(alpha = 0.7f)) },
            modifier = Modifier.fillMaxWidth(),
            colors = OutlinedTextFieldDefaults.colors(focusedTextColor = Color.White, unfocusedTextColor = Color.White)
        )
        Spacer(modifier = Modifier.height(24.dp))
        Button(
            onClick = {
                if (name.trim().isEmpty()) { errorMessage = "Error: Item name empty"; return@Button }
                val qty = quantityText.toIntOrNull()
                if (qty == null || qty <= 0) { errorMessage = "Error: Invalid quantity"; return@Button }
                itemNames.add(name.trim()); itemCategories.add(category); itemQuantities.add(qty); itemComments.add(comment)
                onBackClick()
            },
            modifier = Modifier.fillMaxWidth().height(56.dp),
            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF3282B8)),
            shape = RoundedCornerShape(12.dp)
        ) {
            Text("Save Gear", color = Color.White)
        }
        Spacer(modifier = Modifier.height(12.dp))
        OutlinedButton(onClick = onBackClick, modifier = Modifier.fillMaxWidth().height(56.dp), shape = RoundedCornerShape(12.dp)) {
            Text("Back to Base", color = Color.White)
        }
    }
}

@Composable
fun ChecklistScreen(
    itemNames: List<String>,
    itemCategories: List<String>,
    itemQuantities: List<Int>,
    itemComments: List<String>,
    onBackClick: () -> Unit
) {
    Column(modifier = Modifier.fillMaxSize().padding(24.dp)) {
        Text(text = "Gear Checklist", fontSize = 28.sp, fontWeight = FontWeight.Bold, color = Color.White)
        Spacer(modifier = Modifier.height(16.dp))
        LazyColumn(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            itemsIndexed(itemNames) { index, name ->
                Surface(color = Color.White.copy(alpha = 0.95f), shape = RoundedCornerShape(12.dp), modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text(text = "${index + 1}. $name", fontSize = 18.sp, fontWeight = FontWeight.Bold, color = Color(0xFF1B262C))
                        Text("Category: ${itemCategories[index]}", color = Color(0xFF3282B8))
                        Text("Quantity: ${itemQuantities[index]}", color = Color(0xFF3282B8))
                        Text(text = "Notes: ${itemComments[index]}", fontSize = 14.sp)
                    }
                }
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = onBackClick, modifier = Modifier.fillMaxWidth().height(56.dp), colors = ButtonDefaults.buttonColors(containerColor = Color.White), shape = RoundedCornerShape(12.dp)) {
            Text("Back to Base", color = Color(0xFF0F4C75))
        }
    }
}
